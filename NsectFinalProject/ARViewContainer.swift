import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    class Coordinator {
        var boxEntity: ModelEntity?
        var arView: ARView?
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        let boxMesh = MeshResource.generateBox(size: 0.1)
        let boxMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        context.coordinator.boxEntity = boxEntity

        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(boxEntity)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Não usaremos updateUIView para remover cubo mais
    }
    
    // Função para tentar capturar o cubo via raycast
    func capturarCubo(coordinator: Coordinator) {
        guard let arView = coordinator.arView,
              let boxEntity = coordinator.boxEntity else { return }

        // Centro da tela (em pixels)
        let center = CGPoint(x: arView.bounds.midX, y: arView.bounds.midY)

        // Raycast para detectar entidades 3D no centro da tela
        let results = arView.raycast(from: center, allowing: .estimatedPlane, alignment: .horizontal)

        // Se o raycast acertou algo
        if let firstResult = results.first {
            // Converte a posição do raycast para mundo real
            let raycastPosition = SIMD3<Float>(firstResult.worldTransform.columns.3.x,
                                               firstResult.worldTransform.columns.3.y,
                                               firstResult.worldTransform.columns.3.z)
            
            // Calcula distância entre o cubo e o ponto do raycast
            let distance = distance(boxEntity.position(relativeTo: nil), raycastPosition)
            
            // Se estiver perto o suficiente (ex: menos de 20cm)
            if distance < 0.2 {
                boxEntity.removeFromParent()
                coordinator.boxEntity = nil
                print("Inseto capturado!")
            }
        }
    }
}

