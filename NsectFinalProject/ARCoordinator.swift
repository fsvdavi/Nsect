//
//  ARCoordinator.swift
//  NsectFinalProject
//
//  Created by found on 11/07/25.
//

import RealityKit
import ARKit
import SwiftUI

class ARCoordinator: NSObject, ObservableObject {
    var boxEntity: ModelEntity?
    var arView: ARView?

    @Published var canCapture = false

    func configurarCenaAR() -> ARView {
        let arView = ARView(frame: .zero)
        self.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        let anchor = AnchorEntity(plane: .horizontal)

        do {
            let insectEntity = try ModelEntity.loadModel(named: "ant")
            insectEntity.scale = SIMD3<Float>(0.05, 0.05, 0.05)
            self.boxEntity = insectEntity
            anchor.addChild(insectEntity)
        } catch {
            print("Erro ao carregar o inseto: \(error)")
        }

        // Adiciona o anchor na cena
        arView.scene.anchors.append(anchor)

        // Timer para verificar se pode capturar
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.verificarSePodeCapturar()
        }

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
}
