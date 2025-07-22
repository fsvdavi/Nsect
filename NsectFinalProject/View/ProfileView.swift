import SwiftUI

struct ProfileView: View {
    let topBarHeight: CGFloat = 360

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background imagem
                Image("forestBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .opacity(0.8)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Bar verde com ícone de perfil e textos
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

                    // Aqui entrará o conteúdo futuro

                    Spacer()

                    tabBar
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    var tabBar: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: HomeView()) {
                VStack(spacing: 2) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                }
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)

            NavigationLink(destination: CameraARView()) {
                VStack(spacing: 2) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                            .frame(width: 70, height: 70)

                        Image(systemName: "camera")
                            .foregroundColor(.white)
                            .font(.system(size: 34))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -20)

            VStack(spacing: 2) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 32))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 16)
        .background(
            Color.white
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .shadow(radius: 3)
        )
    }
}

#Preview {
    ProfileView()
}
