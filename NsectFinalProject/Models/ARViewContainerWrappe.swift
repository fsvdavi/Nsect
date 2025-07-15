import SwiftUI
import RealityKit

struct ARViewContainerWrapper: UIViewRepresentable {
    @ObservedObject var coordinator: ARCoordinator

    func makeUIView(context: Context) -> ARView {
        return coordinator.configurarCenaAR()
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Nenhuma atualização dinâmica por enquanto
    }
}

