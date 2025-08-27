import SwiftUI
import RealityKit

struct CameraARView: View {
    @ObservedObject var arCoordinator: ARCoordinator
    @State private var glow = false
    @State private var showSkillCheck = false
    @State private var skillTapToken = UUID()
    @StateObject private var skillVM = SkillCheckViewModel()

    private var isCaptureEnabled: Bool {
        arCoordinator.canCapture
    }

    private var captureButtonFill: Color {
        isCaptureEnabled ? .green : .gray.opacity(0.55)
    }

    var body: some View {
        ZStack {
            // ARView
            ARViewContainerWrapper(coordinator: arCoordinator)
                .edgesIgnoringSafeArea(.all)

            // Mensagem flutuante
            VStack {
                if let mensagem = arCoordinator.mensagem {
                    Text(mensagem)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.green.opacity(0.9), radius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green, lineWidth: 2)
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .shadow(color: Color.green.opacity(glow ? 1 : 0.3), radius: glow ? 10 : 4)
                        .padding(.horizontal, 30)
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: arCoordinator.mensagem)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) { glow = true }
                        }
                        .onDisappear { glow = false }
                }
                Spacer()
            }

            // SkillCheck
            if showSkillCheck {
                SkillCheckView(
                    vm: skillVM,
                    isPresented: $showSkillCheck,
                    onSuccess: {
                        arCoordinator.capturarNsect()
                    },
                    onFail: {
                        arCoordinator.mensagem = "Falhou na captura!"
                        arCoordinator.boxEntity?.removeFromParent()
                        arCoordinator.boxEntity = nil
                        arCoordinator.artropodeAtual = nil
                    },
                    externalTapToken: $skillTapToken
                )
                .allowsHitTesting(false)
            }

            // Botão de captura
            VStack {
                Spacer()
                Button(action: {
                    if showSkillCheck {
                        skillTapToken = UUID() // registra toque na SkillCheck
                    } else if arCoordinator.canCapture {
                        showSkillCheck = true
                        skillVM.currentStage = 1
                        skillVM.hits = 0
                    }
                }) {
                    Circle()
                        .fill(captureButtonFill) // ainda depende só de canCapture
                        .frame(width: 80, height: 80)
                        .shadow(color: isCaptureEnabled ? .green : .black.opacity(0.2), radius: 10)
                        .overlay(
                            Image(systemName: "scope")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                        .scaleEffect(isCaptureEnabled ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isCaptureEnabled)
                }
                .disabled(!arCoordinator.canCapture && !showSkillCheck) // habilita durante SkillCheck

            }
        }
    }
}
