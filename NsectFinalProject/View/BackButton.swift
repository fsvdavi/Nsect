//
//  BackButton.swift
//  NsectFinalProject
//
//  Created by found on 27/08/25.
//


import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var size: CGFloat = 44

    var body: some View {
        Button(action: action) {
            ZStack {
                // Fundo circular com gradiente
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color(hue: 0.33, saturation: 0.8, brightness: 0.35)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size, height: size)
                    .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)

                // Ícone
                Image(systemName: "chevron.left")
                    .font(.system(size: size * 0.45, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
