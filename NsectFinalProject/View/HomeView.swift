import SwiftUI

struct HomeView: View {
    let topBarHeight: CGFloat = 160
    @State private var glow = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Bar
                    HStack {
                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .padding(.leading, 8)
                        
                        Spacer()
                        
                        NavigationLink {
                            ProfileView()
                        } label: {
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Circle().stroke(Color.black, lineWidth: 2)
                                )
                                .padding(.trailing, 24)
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.top, 10)

                    Spacer()

                    // Botões principais
                    VStack(spacing: 20) {
                        // Botão Explorar
                        NavigationLink {
                            CameraARView(arCoordinator: ARCoordinator())
                        } label: {
                            ButtonTemplate(imageName: "templatemadeira", icon: "magnifyingglass", text: "Explorar", glow: glow)
                        }
                        .buttonStyle(.plain)

                        // Botão Inventário
                        NavigationLink {
                            InventoryInsectView(arCoordinator: ARCoordinator())
                        } label: {
                            ButtonTemplate(imageName: "templatemadeira", icon: "backpack.fill", text: "Inventário", glow: glow)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 80)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        glow = true
                    }
                }
            }
        }
        .backgroundMusic(.homeProfile)
    }
}

// Componente reutilizável para os botões
struct ButtonTemplate: View {
    var imageName: String
    var icon: String
    var text: String
    var glow: Bool

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 320, height: 120)
                .scaleEffect(x: 1.0, y: 0.7)
                .cornerRadius(20)
                .shadow(color: Color.green.opacity(glow ? 0.8 : 0.3), radius: glow ? 12 : 5)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)

                Text(text)
                    .font(.custom("Avenir Next Heavy", size: 25))
                    .foregroundStyle(
                        LinearGradient(colors: [Color.white, Color.yellow], startPoint: .top, endPoint: .bottom)
                    )
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 2, y: 2)
            }
            .padding(.leading, -10)
        }
    }
}

#Preview {
    HomeView()
}
