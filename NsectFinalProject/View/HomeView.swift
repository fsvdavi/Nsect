import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: AppTab
    let topBarHeight: CGFloat = 160

    var body: some View {
        ZStack(alignment: .top) {
            // Fundo
            Image("forestBackground")
                .resizable()
                .opacity(0.8)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Barra superior
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

                // Conteúdo principal
                Button {
                    selectedTab = .profile
                } label: {
                    Image("brazilMap")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.35)
                        .shadow(radius: 20)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
    }
}

#Preview {
    struct HomeViewPreviewWrapper: View {
        @State private var selectedTab: AppTab = .home

        var body: some View {
            HomeView(selectedTab: $selectedTab)
        }
    }

    return HomeViewPreviewWrapper()
}
