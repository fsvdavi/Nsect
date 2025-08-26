import RealityKit
import ARKit
import SwiftUI

class ARCoordinator: NSObject, ObservableObject {
    let insetoEscalas: [String: SIMD3<Float>] = [
        "ant": SIMD3<Float>(0.02, 0.02, 0.02),
        "Ladybug": SIMD3<Float>(0.09, 0.09, 0.09),
        "mantis": SIMD3<Float>(0.2, 0.2, 0.2),
        "RedAnt": SIMD3<Float>(0.01, 0.01, 0.01),
        "Scorpion": SIMD3<Float>(0.006, 0.006, 0.006),
        "besouro": SIMD3<Float>(0.002, 0.002, 0.002),
        "spider": SIMD3<Float>(0.03, 0.03, 0.03),
        "AbelhaCarpinteira": SIMD3<Float>(0.05, 0.05, 0.05),
        "AranhaPavão": SIMD3<Float>(0.05, 0.05, 0.05),
        "BesouroBomba": SIMD3<Float>(0.05, 0.05, 0.05),
        "Bicho-Pau": SIMD3<Float>(0.05, 0.05, 0.05),
        "EscorpiaoCaudaChicote": SIMD3<Float>(0.1, 0.1, 0.1),
        "FormigaLeão": SIMD3<Float>(0.05, 0.05, 0.05),
        "gorgulhoGirafa": SIMD3<Float>(0.05, 0.05, 0.05),
        "HatsuneMiku": SIMD3<Float>(0.003, 0.003, 0.003),
        "jewelSpiderglb": SIMD3<Float>(0.1, 0.1, 0.1),
        "LouvaDeusOrquidea": SIMD3<Float>(0.08, 0.08, 0.08)
    ]

    var boxEntity: ModelEntity?
    var arView: ARView?

    @Published var artropodesDisponiveis: [Artropode] = carregarArtropodes()
    @Published var insetosCapturados: [Artropode] = []
    var artropodeAtual: Artropode?

    @Published var canCapture = false
    @Published var mensagem: String? = nil

    @Published var conquistas: [Achievement] = [
        Achievement(title: "Mestre dos Insetos", description: "Capture todos os artrópodes disponíveis", isUnlocked: false),
        Achievement(title: "Explorador Iniciante", description: "Capture seu primeiro inseto", isUnlocked: false),
        Achievement(title: "Caçador Noturno", description: "Capture um inseto à noite", isUnlocked: false),
        Achievement(title: "Entomologista Sênior", description: "Complete o inventário", isUnlocked: false)
    ]

    private var timerCheckCapture: Timer?
    private var timerLoadInseto: Timer?
    private var playerProgress: PlayerProgress?

    var spawnWeights: [PlayerProgress.Rarity: Int] = [
        .comum: 50,
        .raro: 30,
        .epico: 14,
        .lendario: 5,
        .secret: 1
    ]

    func attach(playerProgress: PlayerProgress) {
        self.playerProgress = playerProgress
        Task { await playerProgress.evaluateUnlocksAsync() }
    }

    func configurarCenaAR() -> ARView {
        self.boxEntity = nil
        self.arView = nil
        self.artropodeAtual = nil

        let arView = ARView(frame: .zero)
        self.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)

        carregarInsetoAleatorio(anchor: anchor)

        if timerCheckCapture == nil {
            timerCheckCapture = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.verificarSePodeCapturar()
            }
        }

        if timerLoadInseto == nil {
            timerLoadInseto = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.boxEntity == nil {
                    self.carregarInsetoAleatorio(anchor: anchor)
                }
            }
        }

        return arView
    }

    func verificarSePodeCapturar() {
        guard let arView = arView, let boxEntity = boxEntity else {
            DispatchQueue.main.async { self.canCapture = false }
            return
        }

        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)

        if let firstResult = results.first {
            let raycastPos = SIMD3<Float>(
                firstResult.worldTransform.columns.3.x,
                firstResult.worldTransform.columns.3.y,
                firstResult.worldTransform.columns.3.z
            )
            let dist = distance(boxEntity.position(relativeTo: nil), raycastPos)
            DispatchQueue.main.async { self.canCapture = dist < 0.2 }
        } else {
            DispatchQueue.main.async { self.canCapture = false }
        }
    }

    private func rarityEnum(for art: Artropode) async -> PlayerProgress.Rarity {
        if let pp = playerProgress {
            return await MainActor.run { pp.rarityFromString(art.raridade) }
        } else {
            let folded = art.raridade
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .folding(options: .diacriticInsensitive, locale: .current)
                .lowercased()
            switch folded {
            case "comum","common": return .comum
            case "raro","rare": return .raro
            case "epico","épico","epic": return .epico
            case "lendario","lendário","legendary": return .lendario
            case "secret","secreto": return .secret
            default: return .comum
            }
        }
    }

    private func weight(for art: Artropode) async -> Int {
        let rar = await rarityEnum(for: art)
        return spawnWeights[rar] ?? 0
    }
    
    private func chooseWeighted(_ list: [Artropode]) async -> Artropode? {
        guard !list.isEmpty else { return nil }

        var itemsWithWeight: [(Artropode, Int)] = []
        for art in list {
            let w = await weight(for: art)
            itemsWithWeight.append((art, w))
        }

        let total = itemsWithWeight.reduce(0) { $0 + max(0, $1.1) }

        if total <= 0 {
            if let rnd = list.randomElement() {
                let r = await rarityEnum(for: rnd)
                print("⚠️ Todos pesos = 0. Fallback escolha uniforme -> \(rnd.nomePopular) (\(r.rawValue))")
                return rnd
            }
            return nil
        }

        let target = Int.random(in: 0..<total)
        var acc = 0
        for (art, w) in itemsWithWeight {
            acc += max(0, w)
            if target < acc { return art }
        }

        return itemsWithWeight.first?.0
    }

    func carregarInsetoAleatorio(anchor: AnchorEntity) {
        guard boxEntity == nil else { return }

        Task { [weak self] in
            guard let self = self else { return }

            let artropodesComModelo = self.artropodesDisponiveis.filter { !$0.modelo3d.isEmpty }
            var permitted: [Artropode] = []

            if let pp = self.playerProgress {
                for art in artropodesComModelo {
                    let rar = await MainActor.run { pp.rarityFromString(art.raridade) }
                    if await pp.canSpawn(rarity: rar) {
                        permitted.append(art)
                    }
                }
            } else {
                permitted = artropodesComModelo
            }

            if permitted.isEmpty {
                print("❌ Nenhum artropode permitido para spawn.")
                return
            }

            var countsByRarity: [String: Int] = [:]
            for art in permitted {
                let rar = await rarityEnum(for: art).rawValue
                countsByRarity[rar, default: 0] += 1
            }
            print("🔎 Permitidos para spawn (counts por raridade): \(countsByRarity) — total \(permitted.count)")

            guard let chosen = await chooseWeighted(permitted) else {
                print("❌ Escolha ponderada falhou, escolhendo aleatório simples.")
                if let fallback = permitted.randomElement() {
                    await spawn(artropode: fallback, anchor: anchor)
                }
                return
            }

            let chosenRarity = await rarityEnum(for: chosen)

            // Calcula totalWeight com loop assíncrono
            var totalWeight = 0
            for art in permitted {
                totalWeight += await weight(for: art)
            }

            let chosenWeight = await weight(for: chosen)
            let prob: Double = totalWeight > 0 ? Double(chosenWeight) / Double(totalWeight) : 1.0 / Double(permitted.count)

            print("🎯 Escolhido: \(chosen.nomePopular) (id:\(chosen.id)) — raridade: \(chosenRarity.rawValue) — peso: \(chosenWeight)/total: \(totalWeight) -> prob: \(String(format: "%.2f", prob))")

            await spawn(artropode: chosen, anchor: anchor)
        }
    }


    private func spawn(artropode: Artropode, anchor: AnchorEntity) async {
        await MainActor.run {
            do {
                let entity = try ModelEntity.loadModel(named: artropode.modelo3d)

                // Corrigir modelos que estão tortos
                switch artropode.modelo3d {
                case "AranhaPavão",
                     "BesouroBomba",
                     "Bicho-pau",
                     "EscorpiaoCaudaChicote",
                     "jewelSpiderglb":
                    entity.transform.rotation = simd_quatf(angle: .pi/2, axis: [1,0,0])
                default:
                    break
                }

                entity.scale = self.insetoEscalas[artropode.modelo3d] ?? SIMD3<Float>(0.05, 0.05, 0.05)

                self.boxEntity = entity
                entity.position = SIMD3<Float>(Float.random(in: -0.2...0.2), 0, Float.random(in: -0.2...0.2))
                anchor.addChild(entity)
                self.artropodeAtual = artropode

                self.mensagem = "Inseto próximo detectado!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.mensagem = nil }

                Task {
                    let rar = await rarityEnum(for: artropode)
                    print("✅ Spawn completo: \(artropode.nomePopular) [\(artropode.id)] — raridade: \(rar.rawValue)")
                }

            } catch { print("❌ Erro ao carregar modelo '\(artropode.modelo3d)': \(error)") }
        }
    }



    func capturarNsect() {
        guard let artropode = artropodeAtual else { return }

        DispatchQueue.main.async {
            self.boxEntity?.removeFromParent()
            self.boxEntity = nil
            self.artropodeAtual = nil

            if !artropode.foiCapturado {
                artropode.foiCapturado = true

                if let idx = self.artropodesDisponiveis.firstIndex(where: { $0.id == artropode.id }) {
                    self.artropodesDisponiveis[idx].foiCapturado = true
                    if !self.insetosCapturados.contains(where: { $0.id == artropode.id }) {
                        self.insetosCapturados.append(self.artropodesDisponiveis[idx])
                    }
                } else if !self.insetosCapturados.contains(where: { $0.id == artropode.id }) {
                    self.insetosCapturados.append(artropode)
                }

                self.salvarInventario()
                self.atualizarConquistas()

                if let pp = self.playerProgress {
                    Task { @MainActor in
                        let rarity = await self.rarityEnum(for: artropode)
                        pp.grantXPForCapture(rarity: rarity)
                        print("✨ XP concedido: \(artropode.nomePopular) — raridade: \(rarity.rawValue) — XP: \(pp.xp) Level: \(pp.level)")
                    }
                }
            }

            self.mensagem = "Inseto capturado!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.mensagem = nil }

            print("📥 Capturado: \(artropode.nomePopular) (id: \(artropode.id))")
        }
    }

    deinit {
        timerCheckCapture?.invalidate()
        timerLoadInseto?.invalidate()
    }

    // MARK: - Inventário
    private var caminhoInventario: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("insetosCapturados.json")
    }

    func salvarInventario() {
        let ids = insetosCapturados.map { ArtropodeSalvo(id: $0.id) }
        do {
            let dados = try JSONEncoder().encode(ids)
            try dados.write(to: caminhoInventario)
            print("💾 Inventário salvo (\(ids.count) itens).")
        } catch { print("❌ Erro ao salvar inventário: \(error)") }
    }

    func carregarInventario() {
        do {
            let dados = try Data(contentsOf: caminhoInventario)
            let ids = try JSONDecoder().decode([ArtropodeSalvo].self, from: dados)

            for art in artropodesDisponiveis {
                if ids.contains(where: { $0.id == art.id }) {
                    art.foiCapturado = true
                    if !insetosCapturados.contains(where: { $0.id == art.id }) { insetosCapturados.append(art) }
                }
            }
            print("📥 Inventário carregado (\(insetosCapturados.count) itens).")
        } catch { }
    }

    // MARK: - Conquistas
    private var caminhoConquistas: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("conquistas.json")
    }

    func atualizarConquistas() {
        if insetosCapturados.count >= 1 { desbloquearConquista(titulo: "Explorador Iniciante") }

        let totalComModelo = artropodesDisponiveis.filter { !$0.modelo3d.isEmpty }.count
        if insetosCapturados.count == totalComModelo { desbloquearConquista(titulo: "Mestre dos Insetos") }

        if artropodesDisponiveis.allSatisfy({ $0.foiCapturado }) { desbloquearConquista(titulo: "Entomologista Sênior") }

        let horaAtual = Calendar.current.component(.hour, from: Date())
        if horaAtual >= 18 || horaAtual <= 6 { desbloquearConquista(titulo: "Caçador Noturno") }
    }

    func desbloquearConquista(titulo: String) {
        if let index = conquistas.firstIndex(where: { $0.title == titulo && !$0.isUnlocked }) {
            conquistas[index].isUnlocked = true
            salvarConquistas()
            print("🏆 Conquista desbloqueada: \(titulo)")
        }
    }

    func salvarConquistas() {
        let conquistasSalvas = conquistas.map { AchievementSalvo(title: $0.title, isUnlocked: $0.isUnlocked) }
        do {
            let dados = try JSONEncoder().encode(conquistasSalvas)
            try dados.write(to: caminhoConquistas)
        } catch { print("❌ Erro ao salvar conquistas: \(error)") }
    }

    func carregarConquistas() {
        do {
            let dados = try Data(contentsOf: caminhoConquistas)
            let conquistasSalvas = try JSONDecoder().decode([AchievementSalvo].self, from: dados)
            for cs in conquistasSalvas {
                if let index = conquistas.firstIndex(where: { $0.title == cs.title }) {
                    conquistas[index].isUnlocked = cs.isUnlocked
                }
            }
        } catch { }
    }

    override init() {
        super.init()
        carregarInventario()
        carregarConquistas()
    }
}

// MARK: - Helper Async Reduce
extension Array {
    func asyncReduce<Result>(_ initial: Result, _ transform: (Result, Element) async -> Result) async -> Result {
        var result = initial
        for element in self {
            result = await transform(result, element)
        }
        return result
    }
}
