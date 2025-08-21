//import SwiftUI
//
//struct MainView: View {
//    @StateObject private var arCoordinator = ARCoordinator() 
//
//    @State private var selectedTab: AppTab = .home
//    @State private var showCamera = false
//
//    var body: some View {
////        ZStack {
////            switch selectedTab {
////            case .home:
////                HomeView(selectedTab: $selectedTab)
////            case .profile:
////                ProfileView(selectedTab: $selectedTab, showCamera: $showCamera, coordinator: arCoordinator)
////            case .inventory:
////                InventoryInsectView(arCoordinator: arCoordinator)
////            }
//
//            VStack {
//                Spacer()
//                TabBar(selectedTab: $selectedTab, showCamera: $showCamera)
//                    .frame(maxWidth: .infinity)
//            }
//        }
//        .ignoresSafeArea(edges: .bottom)
//        .fullScreenCover(isPresented: $showCamera) {
//            CameraARView(arCoordinator: arCoordinator)
//        }
//    }
//}
//
//#Preview {
//    MainView()
//}
