import SwiftUI

struct HomeView: View {
    let topBarHeight: CGFloat = 160
    @State private var glow = false
    @State private var showComingSoon = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // Background
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
                            .padding(.leading, -2)
                        
                        Spacer()
                        
                        // Botão Perfil com animação
                        NavigationLink {
                            ProfileView()
                        } label: {
                            AnimatedCircleImage(imageName: "hatsunemikuprofile", size: 80)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 24)
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Botões principais
                    VStack(spacing: 10) {
                        
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
                        
                        // Quadradinhos abaixo com animação
                        HStack(spacing: 20) {
                            AnimatedButtonImage(imageName: "configuracao") {
                                showComingSoon = true
                            }
                            
                            AnimatedButtonImage(imageName: "classificacao") {
                                showComingSoon = true
                            }
                        }
                        .padding(.top, -5)
                    }
                    .padding(.bottom, 50)
                }
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        glow = true
                    }
                }
                
                // Texto da empresa
                VStack {
                    Spacer()
                    HStack {
                        Text("Nsect ©")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.9))
                            .padding(.leading, 26)
                            .padding(.bottom, -16)
                        Spacer()
                    }
                }
                
                // Overlay "Em desenvolvimento"
                if showComingSoon {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                        
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.8), Color(red: 1.0, green: 1.0, blue: 0.6, opacity: 0.5)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 270, height: 260)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.black, lineWidth: 3)
                                )
                                .shadow(color: Color.green.opacity(0.5), radius: 8, x: 0, y: 4)
                            
                            Button(action: {
                                showComingSoon = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                            }
                            .padding(10)
                        }
                        
                        Text("Este recurso ainda está em desenvolvimento")
                            .font(.custom("Avenir Next Heavy", size: 16))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.8), Color(red: 0.8, green: 0.8, blue: 0.6, opacity: 0.5)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1)
                            .multilineTextAlignment(.center)
                            .frame(width: 240)
                    }
                    .transition(.opacity.combined(with: .scale))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: showComingSoon)
                }
            }
            .backgroundMusic(.homeProfile)
        }
    }
}

// Componente reutilizável para os botões principais
struct ButtonTemplate: View {
    var imageName: String
    var icon: String
    var text: String
    var glow: Bool
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 280, height: 100)
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
        .scaleEffect(isPressed ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        .onTouchGesture { pressing in
            isPressed = pressing
        }
    }
}

// Botão circular animado para perfil
struct AnimatedCircleImage: View {
    var imageName: String
    var size: CGFloat
    @State private var isPressed = false
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
            .opacity(0.8)
            .scaleEffect(isPressed ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
            .onTouchGesture { pressing in
                isPressed = pressing
            }
    }
}

// Novo componente animado para os quadradinhos
struct AnimatedButtonImage: View {
    var imageName: String
    var action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
                .scaleEffect(isPressed ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isPressed)
        }
        .onTouchGesture { pressing in
            isPressed = pressing
        }
    }
}

// Extensão para detectar toque de forma contínua
extension View {
    func onTouchGesture(perform: @escaping (Bool) -> Void) -> some View {
        self.modifier(TouchGestureModifier(perform: perform))
    }
}

struct TouchGestureModifier: ViewModifier {
    let perform: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in perform(true) }
                    .onEnded { _ in perform(false) }
            )
    }
}

#Preview {
    HomeView()
}
