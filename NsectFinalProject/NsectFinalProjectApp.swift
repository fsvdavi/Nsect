//
//  NsectFinalProjectApp.swift
//  NsectFinalProject
//
//  Created by found on 04/07/25.
//


import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.85
    @State private var logoOpacity: Double = 0.85

    var body: some View {
        if isActive {
            HomeView() // vai para a tela principal quando isActive == true
        } else {
            VStack(spacing: 12) {
                Image("nsectLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)

                Image("nsectTitle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.top, 8)
                    .scaleEffect(0.98)
                    .opacity(0.95)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                // gradiente do verde escuro para o branco
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.03, green: 0.25, blue: 0.12), // verde escuro
                        Color(red: 0.12, green: 0.40, blue: 0.20).opacity(0.85),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .onAppear {
                // animação suave do logo enquanto a splash está visível
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    logoScale = 1.03
                    logoOpacity = 1.0
                }

                // mantém a splash por 2s e então navega para HomeView
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeInOut) {
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
