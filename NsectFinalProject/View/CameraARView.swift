import SwiftUI

struct CameraARView: View {
    @ObservedObject var arCoordinator: ARCoordinator
    @State private var glow = false
    @State private var showSkillCheck = false
    @State private var skillTapToken = UUID()   // token de clique para o SkillCheck

    var body: some View {
        ZStack {
            // Câmera
            ARViewContainerWrapper(coordinator: arCoordinator)
                .edgesIgnoringSafeArea(.all)

            // Mensagem
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
                                .shadow(color: Color.green.opacity(0.7), radius: 8)
                        )
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .shadow(color: Color.green.opacity(glow ? 1 : 0.3), radius: glow ? 10 : 4)
                        .padding(.horizontal, 30)
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: arCoordinator.mensagem)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                                glow = true
                            }
                        }
                        .onDisappear { glow = false }
                }
                Spacer()
            }

            // ⬇️ SkillCheck transparente (vem ANTES do botão para ficar por trás dele)
            if showSkillCheck {
                SkillCheckView(
                    isPresented: $showSkillCheck,
                    onSuccess: { arCoordinator.capturarNsect() },
                    onFail: { arCoordinator.mensagem = "Falhou na captura!" },
                    externalTapToken: $skillTapToken
                )
                // Sem background, sem frame fixo → nada de quadrado preto
            }

            // Botão de capturar (o MESMO de sempre)
            VStack {
                Spacer()
                Button(action: {
                    if showSkillCheck {
                        // Estamos no mini-jogo → encaminha o clique
                        skillTapToken = UUID()
                    } else {
                        // Abre o mini-jogo
                        if arCoordinator.canCapture {
                            showSkillCheck = true
                        }
                    }
                }) {
                    Circle()
                        .fill(Color.green) // mantém verde durante o skill
                        .frame(width: 80, height: 80)
                        .shadow(color: .green, radius: 10)
                        .overlay(
                            Image(systemName: "scope")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                        .scaleEffect(arCoordinator.canCapture || showSkillCheck ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: arCoordinator.canCapture || showSkillCheck)
                }
                // Durante o skill, o botão precisa ficar ATIVO mesmo que canCapture seja false
                .disabled(!arCoordinator.canCapture && !showSkillCheck)
                .padding(.bottom, 40)
            }
        }
    }
}
