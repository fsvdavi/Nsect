import SwiftUI

struct HomeView: View {
    let topBarHeight: CGFloat = 160

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
                    // Barra superior verde com cantos arredondados só embaixo
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 0, green: 0.3, blue: 0))
                            .clipShape(RoundedCorners(radius: 40, corners: [.bottomLeft, .bottomRight]))

                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.horizontal, 16)
                            .padding(.top, 40)
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .ignoresSafeArea(edges: .top) // essencial para não cortar os cantos arredondados
                    .padding(.bottom, 10)

                    Spacer()

                    // Conteúdo principal - mapa
                    Image("brazilMap")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.35)
                        .shadow(radius: 20)

                    Spacer()

                    // Tab bar fixa
                    tabBar
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }

    var tabBar: some View {
        HStack(spacing: 0) {
            VStack(spacing: 2) {
                Image(systemName: "house.fill")
                    .font(.system(size: 28))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.gray)

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

            NavigationLink(destination: InventoryInsectView()) {
                VStack(spacing: 2) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                }
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
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
    HomeView()
}
