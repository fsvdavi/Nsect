//
//  MainView.swift
//  NsectFinalProject
//
//  Created by found on 22/07/25.
//

import SwiftUI

enum Tab {
    case home, camera, inventory
}

struct MainView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            // Conteúdo dinâmico conforme a aba
            switch selectedTab {
            case .home:
                HomeView()
            case .camera:
                CameraARView()
            case .inventory:
                InventoryInsectView()
            }

            // Tab bar fixa na parte de baixo
            VStack {
                Spacer()
                TabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    MainView()
}
