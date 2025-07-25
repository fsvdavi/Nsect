import SwiftUI

struct CameraARView: View {
    @StateObject private var arCoordinator = ARCoordinator()
    @State private var glow = false

    //  dismiss para fechar a tela cheia
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        ZStack {
            // Ocupar toda tela
            ARViewContainerWrapper(coordinator: arCoordinator)
                .edgesIgnoringSafeArea(.all)

            
            //  Botão de voltar
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)

                    Spacer()
                }
                Spacer()
            }

            // Mensagem de captura
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
                        .onDisappear {
                            glow = false
                        }
                }
                Spacer()
            }

            // Botão pra capturar
            VStack {
                Spacer()

                Button(action: {
                    arCoordinator.capturarNsect()
                }) {
                    Circle()
                        .fill(arCoordinator.canCapture ? Color.green : Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                        .shadow(color: arCoordinator.canCapture ? .green : .clear, radius: 10)
                        .overlay(
                            Image(systemName: "scope")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                        .scaleEffect(arCoordinator.canCapture ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: arCoordinator.canCapture)
                }
                .disabled(!arCoordinator.canCapture)
                .padding(.bottom, 40)
            }
        }
    }
}
