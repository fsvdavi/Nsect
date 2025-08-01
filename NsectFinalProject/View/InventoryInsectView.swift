import SwiftUI

struct InventoryInsectView: View {
    @ObservedObject var arCoordinator: ARCoordinator
    @Binding var selectedTab: AppTab
    @Binding var selectedInseto: Artropode?

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
                Image("forestBackground")
                    .resizable()
                    .opacity(0.8)
                    .ignoresSafeArea()

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(arCoordinator.insetosCapturados) { inseto in
                            Button {
                                selectedInseto = inseto
                            } label: {
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


struct InventoryInsectView_Previews: PreviewProvider {
    @State static var selectedTab: AppTab = .inventory
    @State static var selectedInseto: Artropode? = carregarArtropodes().first

    static var previews: some View {
        InventoryInsectView(
            arCoordinator: {
                let coordinator = ARCoordinator()
                // Simula insetos capturados no preview
                coordinator.insetosCapturados = carregarArtropodes().prefix(4).map { art in
                    let copy = art
                    copy.foiCapturado = true
                    return copy
                }
                return coordinator
            }(),
            selectedTab: $selectedTab,
            selectedInseto: $selectedInseto
        )
    }
}
