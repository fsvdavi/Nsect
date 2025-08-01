import SwiftUI

struct MainView: View {
    @StateObject private var arCoordinator = ARCoordinator()

    @State private var selectedTab: AppTab = .home
    @State private var showCamera = false

    @State private var selectedInseto: Artropode? = nil

    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(selectedTab: $selectedTab)
            case .profile:
                ProfileView(
                    selectedTab: $selectedTab,
                    showCamera: $showCamera,
                    coordinator: arCoordinator
                )
            case .inventory:
                InventoryInsectView(
                    arCoordinator: arCoordinator,
                    selectedTab: $selectedTab,
                    selectedInseto: $selectedInseto
                )
            }

            // Mostra o detalhe do inseto em overlay
            if let inseto = selectedInseto {
                InsetoDetailView(artropode: inseto)
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
                    .overlay(alignment: .topTrailing) {
                        Button(action: {
                            selectedInseto = nil
                            selectedTab = .inventory
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
            }

            VStack {
                Spacer()
                TabBar(
                    selectedTab: $selectedTab,
                    showCamera: $showCamera
                )
                .frame(maxWidth: .infinity)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showCamera) {
            CameraARView(arCoordinator: arCoordinator)
        }
    }
}


#Preview {
    MainView()
}
