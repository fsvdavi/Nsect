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
                        Color(red: 0, green: 0.3, blue: 0)
                            .mask(
                                RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .padding(.top, -20)
                            )

                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.horizontal, 16)
                            .padding(.top, 40)
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .ignoresSafeArea(edges: .top)
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
                    TabBar()
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    HomeView()
}


