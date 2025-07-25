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
    let insetoEscalas: [String: SIMD3<Float>] = [
        "ant": SIMD3<Float>(0.02, 0.02, 0.02),
        "Ladybug": SIMD3<Float>(0.09, 0.09, 0.09),
        "mantis": SIMD3<Float>(0.2, 0.2, 0.2),
        "RedAnt": SIMD3<Float>(0.01, 0.01, 0.01),
        "Scorpion": SIMD3<Float>(0.006, 0.006, 0.006)
    ]

    var boxEntity: ModelEntity?
    var arView: ARView?
    
    @Published var artropodesDisponiveis: [Artropode] = carregarArtropodes()
    @Published var insetosCapturados: [Artropode] = []
    var artropodeAtual: Artropode?
    
    @Published var showConfetti = false
    @Published var canCapture = false
    @Published var mensagem: String? = nil


    func configurarCenaAR() -> ARView {
        let arView = ARView(frame: .zero)
        self.arView = arView

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)

        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.anchors.append(anchor)

        carregarInsetoAleatorio(anchor: anchor)

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.verificarSePodeCapturar()
        }

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.carregarInsetoAleatorio(anchor: anchor)
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
        guard boxEntity == nil else { return }

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

                    // ✅ Armazena o artropode capturado
                    if !self.insetosCapturados.contains(where: { $0.id == artropode.id }) {
                        self.insetosCapturados.append(artropode)
                        print("✅ Capturado: \(artropode.nomePopular)")
                    }

                    self.mensagem = "Inseto capturado!"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.mensagem = nil
                    }
                }
            }
        }
    }
}
