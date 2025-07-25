//
//  TabBar.swift
//  NsectFinalProject
//
//  Created by found on 25/07/25.
//

import SwiftUI

enum AppTab {
    case home, inventory
}

struct TabBar: View {
    @Binding var selectedTab: AppTab
    @Binding var showCamera: Bool

    var body: some View {
        HStack(spacing: 0) {
            // Botão Home
            Button {
                selectedTab = .home
            } label: {
                VStack {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .home ? .green : .gray)
            }

            // Botão Câmera (abre a camera via modal)
            Button {
                showCamera = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                        .frame(width: 70, height: 70)

                    Image(systemName: "camera")
                        .foregroundColor(.white)
                        .font(.system(size: 34))
                }
            }
            .frame(maxWidth: .infinity)
            .offset(y: -20)
            // Botão Perfil
            Button {
                selectedTab = .inventory
            } label: {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .inventory ? .green : .gray)
            }
        }
//        .padding(.vertical, 1)
//        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .opacity(0.85)
                .shadow(radius: 3)
        )
    }
}

#Preview {
   
    struct TabBarPreview: View {
        @State private var selectedTab: AppTab = .home
        @State private var showCamera = false

        var body: some View {
            TabBar(selectedTab: $selectedTab, showCamera: $showCamera)
                .padding() // Para dar espaço ao redor no preview
                .background(Color.gray.opacity(0.2)) // Para visualização clara
        }
    }

    return TabBarPreview()
}
