import SwiftUI

struct InventoryInsectView: View {
    let topBarHeight: CGFloat = 160
    let insetos: [Artropode] = carregarArtropodes()
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
        
        NavigationStack {
            ZStack(alignment: .top) {
                
                // Fundo com imagem
                Image("forestBackground")
                    .resizable()
                    .opacity(0.8)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(insetos) { inseto in
                            NavigationLink(destination: InsetoDetailView(artropode: inseto)) {
                                MoldInsectView(insect: inseto)
                            }
                            .buttonStyle(PlainButtonStyle()) // remove o efeito de botão padrão
                        }
                    }
                    .padding()
                    .padding(.top, 50)
                }

                ZStack {
                    Rectangle()
                        .fill(Color(red: 0, green: 0.3, blue: 0))
                        .clipShape(RoundedCorners(radius: 20, corners: [.bottomLeft, .bottomRight]))

                    Image("nsectTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.horizontal, 16)
                        .padding(.top, 40)
                }
                .frame(height: topBarHeight)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

#Preview {
    InventoryInsectView()
}
