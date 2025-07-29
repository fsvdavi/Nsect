import SwiftUI

struct InventoryInsectView: View {
    @ObservedObject var arCoordinator: ARCoordinator

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
                Image("forestBackground")
                    .resizable()
                    .opacity(0.8)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(arCoordinator.insetosCapturados) { inseto in
                            NavigationLink(destination: InsetoDetailView(artropode: inseto)) {
                                MoldInsectView(insect: inseto)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .padding(.top, 50)
                }

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
                .frame(height: 160)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}


#Preview {
    InventoryInsectView(arCoordinator: ARCoordinator())
}

