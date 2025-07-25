import SwiftUI

struct ProfileView: View {
    let topBarHeight: CGFloat = 360
    @Binding var selectedTab: AppTab
    @Binding var showCamera: Bool
    struct RoundedCorners: Shape {
        var radius: CGFloat = 25.0
        var corners: UIRectCorner = [.bottomLeft, .bottomRight]

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
    var body: some View {
        ZStack(alignment: .top) {
            // Fundo da tela
            Image("forestBackground")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 0, green: 0.3, blue: 0))
                        .clipShape(RoundedCorners(radius: 40, corners: [.bottomLeft, .bottomRight]))
                    
                    VStack(spacing: 12) {
                        Text("PROFILE")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 130, height: 130)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .padding(20)
                            )
                        
                        Text("Nome do Usuário")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 34)
                        
                        Text("Conquistas")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                }
                .frame(height: topBarHeight)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                .ignoresSafeArea(edges: .top)
                .padding(.bottom, 10)
                
                Spacer()
                
                // Conteúdo futuro aqui
                
                Spacer()
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    ProfilePreviewWrapper()
}

private struct ProfilePreviewWrapper: View {
    @State private var selectedTab: AppTab = .profile
    @State private var showCamera: Bool = false

    var body: some View {
        ProfileView(selectedTab: $selectedTab, showCamera: $showCamera)
    }
}
