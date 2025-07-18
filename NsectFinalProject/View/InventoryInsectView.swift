import SwiftUI

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

struct InventoryInsectView: View {
    let topBarHeight: CGFloat = 160

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(1..<10) { index in
                        MoldInsectView(id: index, nome: "Inseto \(index)", cor: .blue)
                    }
                }
                .padding()
                .padding(.top, 100)
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
                    .padding(.top, 40)  // afasta a imagem do topo, fazendo "descer"
            }
            .frame(height: topBarHeight)
            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    InventoryInsectView()
}
