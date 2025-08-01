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

    @Published var showConfetti = false
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
    
    // MARK: - Cena AR
    
    func configurarCenaAR() -> ARView {
        print("🔄 Configurando ARView e resetando estado")

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

        timerCheckCapture?.invalidate()
        timerLoadInseto?.invalidate()

        timerCheckCapture = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.verificarSePodeCapturar()
        }

        timerLoadInseto = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.boxEntity == nil {
                self.carregarInsetoAleatorio(anchor: anchor)
            }
        }

        return arView
    }

    func verificarSePodeCapturar() {
        guard let arView = arView,
              let boxEntity = boxEntity else {
            DispatchQueue.main.async {
                self.canCapture = false
            }
            return
        }

        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)

        if let firstResult = results.first {
            let raycastPosition = SIMD3<Float>(
                firstResult.worldTransform.columns.3.x,
                firstResult.worldTransform.columns.3.y,
                firstResult.worldTransform.columns.3.z
            )

            let distance = distance(boxEntity.position(relativeTo: nil), raycastPosition)

            DispatchQueue.main.async {
                self.canCapture = distance < 0.2
            }
        } else {
            DispatchQueue.main.async {
                self.canCapture = false
            }
        }
    }

    func carregarInsetoAleatorio(anchor: AnchorEntity) {
        guard boxEntity == nil else {
            return
        }

        let artropodesComModelo = artropodesDisponiveis.filter { !$0.modelo3d.isEmpty }
        guard let artropode = artropodesComModelo.randomElement() else {
            print("❌ Nenhum artropode com modelo3d válido.")
            return
        }
        artropodeAtual = artropode

        do {
            let entity = try ModelEntity.loadModel(named: artropode.modelo3d)
            entity.scale = insetoEscalas[artropode.modelo3d] ?? SIMD3<Float>(0.05, 0.05, 0.05)

            if artropode.modelo3d == "mantis" {
                entity.transform.rotation = simd_quatf(angle: .pi, axis: [0, 1, 0])
            }

            self.boxEntity = entity
            let randomX = Float.random(in: -0.2...0.2)
            let randomZ = Float.random(in: -0.2...0.2)
            entity.position = SIMD3<Float>(randomX, 0, randomZ)
            anchor.addChild(entity)

            DispatchQueue.main.async {
                self.mensagem = "Inseto encontrado!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.mensagem = nil
                }
            }

            print("Inseto carregado: \(artropode.nomePopular)")
        } catch {
            print("❌ Erro ao carregar modelo '\(artropode.modelo3d)': \(error)")
        }
    }

    func capturarNsect() {
        guard let arView = arView,
              let boxEntity = boxEntity,
              let artropode = artropodeAtual else { return }

        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)

        if let firstResult = results.first {
            let raycastPosition = SIMD3<Float>(
                firstResult.worldTransform.columns.3.x,
                firstResult.worldTransform.columns.3.y,
                firstResult.worldTransform.columns.3.z
            )

            let distance = distance(boxEntity.position(relativeTo: nil), raycastPosition)

            if distance < 0.2 {
                let transform = Transform(
                    scale: SIMD3<Float>(repeating: 0.0),
                    rotation: boxEntity.transform.rotation,
                    translation: boxEntity.transform.translation
                )

                boxEntity.move(to: transform, relativeTo: boxEntity.parent, duration: 0.8, timingFunction: .easeInOut)

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    self.boxEntity?.removeFromParent()
                    self.boxEntity = nil
                    self.artropodeAtual = nil

                    if !self.insetosCapturados.contains(where: { $0.id == artropode.id }) {
                        if let index = self.artropodesDisponiveis.firstIndex(where: { $0.id == artropode.id }) {
                            self.artropodesDisponiveis[index].foiCapturado = true
                            self.insetosCapturados.append(self.artropodesDisponiveis[index])
                        } else {
                            let novo = artropode
                            novo.foiCapturado = true
                            self.insetosCapturados.append(novo)
                        }

                        self.salvarInventario()
                        self.atualizarConquistas()
                    }


                    print("✅ Capturado: \(artropode.nomePopular)")
                }

                DispatchQueue.main.async {
                    self.mensagem = "Inseto descoberto!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.mensagem = nil
                    }
                }
            }
        }
    }

    deinit {
        timerCheckCapture?.invalidate()
        timerLoadInseto?.invalidate()
    }
    // MARK: - Salvamento e Carregamento de Inventário

    private var caminhoInventario: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("insetosCapturados.json")
    }

    func salvarInventario() {
        let ids = insetosCapturados.map { ArtropodeSalvo(id: $0.id) }
        do {
            let dados = try JSONEncoder().encode(ids)
            try dados.write(to: caminhoInventario)
            print("Inventário salvo.")
        } catch {
            print("Erro ao salvar inventário: \(error)")
        }
    }

    func carregarInventario() {
        do {
            let dados = try Data(contentsOf: caminhoInventario)
            let ids = try JSONDecoder().decode([ArtropodeSalvo].self, from: dados)
            let capturados = artropodesDisponiveis.filter { art in
                ids.contains(where: { $0.id == art.id })
            }

            for art in capturados {
                art.foiCapturado = true
            }
            insetosCapturados = capturados

            print("Inventário carregado.")
        } catch {
            print("Nenhum inventário salvo ou erro ao carregar: \(error)")
        }
    }
    
    // MARK: - Salvamento e Carregamento de Conquistas

    private var caminhoConquistas: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("conquistas.json")
    }
    
    func atualizarConquistas() {
        if insetosCapturados.count >= 1 {
            desbloquearConquista(titulo: "Explorador Iniciante")
        }

        let totalComModelo = artropodesDisponiveis.filter { !$0.modelo3d.isEmpty }.count
        if insetosCapturados.count == totalComModelo {
            desbloquearConquista(titulo: "Mestre dos Insetos")
        }

        let todosCapturados = artropodesDisponiveis.filter { $0.foiCapturado }.count
        if todosCapturados == artropodesDisponiveis.count {
            desbloquearConquista(titulo: "Entomologista Sênior")
        }

        let horaAtual = Calendar.current.component(.hour, from: Date())
        if horaAtual >= 18 || horaAtual <= 6 {
            desbloquearConquista(titulo: "Caçador Noturno")
        }
    }
    
    func desbloquearConquista(titulo: String) {
        if let index = conquistas.firstIndex(where: { $0.title == titulo && !$0.isUnlocked }) {
            conquistas[index].isUnlocked = true
            print("🏆 Conquista desbloqueada: \(titulo)")
            salvarConquistas()
        }
    }

    func salvarConquistas() {
        let conquistasSalvas = conquistas.map { AchievementSalvo(title: $0.title, isUnlocked: $0.isUnlocked) }
        do {
            let dados = try JSONEncoder().encode(conquistasSalvas)
            try dados.write(to: caminhoConquistas)
            print("🏅 Conquistas salvas.")
        } catch {
            print("❌ Erro ao salvar conquistas: \(error)")
        }
    }

    func carregarConquistas() {
        do {
            let dados = try Data(contentsOf: caminhoConquistas)
            let conquistasSalvas = try JSONDecoder().decode([AchievementSalvo].self, from: dados)

            for conquistaSalva in conquistasSalvas {
                if let index = conquistas.firstIndex(where: { $0.title == conquistaSalva.title }) {
                    conquistas[index].isUnlocked = conquistaSalva.isUnlocked
                }
            }

            print("📥 Conquistas carregadas.")
        } catch {
            print("⚠️ Nenhuma conquista salva ou erro ao carregar: \(error)")
        }
    }
    
    override init() {
        super.init()
        carregarInventario()
        carregarConquistas()
    }
    
}
