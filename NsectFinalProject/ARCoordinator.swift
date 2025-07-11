import RealityKit
import ARKit
import SwiftUI

class ARCoordinator: NSObject, ObservableObject {
    var boxEntity: ModelEntity?
    var arView: ARView?

    func configurarCenaAR() -> ARView {
        let arView = ARView(frame: .zero)
        self.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        let boxMesh = MeshResource.generateBox(size: 0.1)
        let boxMaterial = SimpleMaterial(color: .blue, isMetallic: true)
        let boxEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        self.boxEntity = boxEntity

        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(boxEntity)
        arView.scene.anchors.append(anchor)

        return arView
    }

    func capturarCubo() {
        guard let arView = arView,
              let boxEntity = boxEntity else { return }

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
                boxEntity.removeFromParent()
                self.boxEntity = nil
                print("Inseto capturado!")
            }
        }
    }
}

