//
//  MainView.swift
//  NsectFinalProject
//
//  Created by found on 25/07/25.
//

// Evitar abrir telas repetidas

import SwiftUI

struct MainView: View {
    @StateObject private var arCoordinator = ARCoordinator() // centraliza aqui

    @State private var selectedTab: AppTab = .home
    @State private var showCamera = false

    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                HomeView(selectedTab: $selectedTab)
            case .profile:
                ProfileView(selectedTab: $selectedTab, showCamera: $showCamera)
            case .inventory:
                InventoryInsectView(arCoordinator: arCoordinator)
            }

            VStack {
                Spacer()
                TabBar(selectedTab: $selectedTab, showCamera: $showCamera)
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

