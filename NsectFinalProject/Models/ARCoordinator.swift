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
        "spider": SIMD3<Float>(0.03, 0.03, 0.03)
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

    // Referência ao progresso do jogador
    private var playerProgress: PlayerProgress?

    func attach(playerProgress: PlayerProgress) {
        self.playerProgress = playerProgress
        Task { await playerProgress.evaluateUnlocks() }
    }

    // MARK: - Configuração da Cena AR
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
            timerLoadInseto = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
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

    // MARK: - carregarInsetoAleatorio
    func carregarInsetoAleatorio(anchor: AnchorEntity) {
        guard boxEntity == nil else { return }

        Task { [weak self] in
            guard let self = self else { return }

            let artropodesComModelo = self.artropodesDisponiveis.filter { !$0.modelo3d.isEmpty }

            var permitted: [Artropode] = []
            if let pp = self.playerProgress {
                for art in artropodesComModelo {
                    if let rarityEnum = PlayerProgress.Rarity(rawValue: art.raridade),
                       await pp.canSpawn(rarity: rarityEnum) {
                        permitted.append(art)
                    }
                }
            } else {
                permitted = artropodesComModelo
            }

            guard let artropode = permitted.randomElement() else {
                print("❌ Nenhum artropode permitido para spawn.")
                return
            }

            await MainActor.run {
                do {
                    let entity = try ModelEntity.loadModel(named: artropode.modelo3d)
                    entity.scale = self.insetoEscalas[artropode.modelo3d] ?? SIMD3<Float>(0.05, 0.05, 0.05)
                    if artropode.modelo3d == "mantis" {
                        entity.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])
                    }

                    self.boxEntity = entity
                    entity.position = SIMD3<Float>(Float.random(in: -0.2...0.2), 0, Float.random(in: -0.2...0.2))
                    anchor.addChild(entity)

                    self.artropodeAtual = artropode
                    self.mensagem = "Inseto encontrado!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.mensagem = nil }
                } catch {
                    print("Erro ao carregar modelo '\(artropode.modelo3d)': \(error)")
                }
            }
        }
    }

    // MARK: - Captura
    func capturarNsect() {
        guard let artropode = artropodeAtual else { return }

        DispatchQueue.main.async {
            self.boxEntity?.removeFromParent()
            self.boxEntity = nil
            self.artropodeAtual = nil

            if !self.insetosCapturados.contains(where: { $0.id == artropode.id }) {
                if let index = self.artropodesDisponiveis.firstIndex(where: { $0.id == artropode.id }) {
                    self.artropodesDisponiveis[index].foiCapturado = true
                    self.insetosCapturados.append(self.artropodesDisponiveis[index])
                } else {
                    var novo = artropode
                    novo.foiCapturado = true
                    self.insetosCapturados.append(novo)
                }
                self.salvarInventario()
                self.atualizarConquistas()

                // ✅ Concede XP baseado na raridade
                if let pp = self.playerProgress,
                   let rarityEnum = PlayerProgress.Rarity(rawValue: artropode.raridade) {
                    Task { @MainActor in
                        pp.grantXPForCapture(rarity: rarityEnum)
                    }
                }
            }

            self.mensagem = "Inseto capturado!"
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.mensagem = nil }
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
        } catch {
            print("Erro ao salvar inventário: \(error)")
        }
    }

    func carregarInventario() {
        do {
            let dados = try Data(contentsOf: caminhoInventario)
            let ids = try JSONDecoder().decode([ArtropodeSalvo].self, from: dados)
            let capturados = artropodesDisponiveis.filter { art in ids.contains(where: { $0.id == art.id }) }
            for art in capturados { art.foiCapturado = true }
            insetosCapturados = capturados
        } catch {
            print("Nenhum inventário salvo ou erro ao carregar: \(error)")
        }
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
        }
    }

    func salvarConquistas() {
        let conquistasSalvas = conquistas.map { AchievementSalvo(title: $0.title, isUnlocked: $0.isUnlocked) }
        do {
            let dados = try JSONEncoder().encode(conquistasSalvas)
            try dados.write(to: caminhoConquistas)
        } catch { print("Erro ao salvar conquistas: \(error)") }
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
        } catch {
            print("Nenhuma conquista salva ou erro ao carregar: \(error)")
        }
    }

    override init() {
        super.init()
        carregarInventario()
        carregarConquistas()
    }
}
