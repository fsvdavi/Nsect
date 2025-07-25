//
//  MainView.swift
//  NsectFinalProject
//
//  Created by found on 25/07/25.
//

// Evitar abrir telas repetidas

import SwiftUI

struct MainView: View {
    @State private var selectedTab: AppTab = .home
    @State private var showCamera = false

    var body: some View {
        ZStack {
            // Conteúdo principal da aba selecionada
            switch selectedTab {
            case .home:
                HomeView()
            case .inventory:
//                InventoryInsectView()
                HomeView()
            }

            // Tab bar fixa em todas as telas
            VStack {
                Spacer()
                TabBar(selectedTab: $selectedTab, showCamera: $showCamera)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .fullScreenCover(isPresented: $showCamera) {
            CameraARView()
        }
    }
}


#Preview {
    MainView()
}

