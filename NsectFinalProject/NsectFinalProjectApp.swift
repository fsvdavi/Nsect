//
//  NsectFinalProjectApp.swift
//  NsectFinalProject
//
//  Created by found on 04/07/25.
//


import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            HomeView() // depois vai para sua tela principal
        } else {
            VStack {
                Image("nsectLogo") // sua logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                Image("nsectTitle") // nome do app
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.top, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white) // cor de fundo da intro
            .ignoresSafeArea()
            .onAppear {
                // tempo que a tela fica visível antes de mudar
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

@main
struct MeuApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
