//
//  AchievementPopupView.swift
//  NsectFinalProject
//
//  Created by found on 28/08/25.
//


import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    init(style: UIBlurEffect.Style = .systemMaterial) { self.style = style }
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


struct AchievementPopupView: View {
    let achievement: Achievement

    @State private var show = false

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "rosette")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(LinearGradient(colors: [Color.yellow, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .padding(.leading, 8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(achievement.title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                    if !achievement.description.isEmpty {
                        Text(achievement.description)
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .opacity(0.9)
                    }
                }
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: 320)
        .background(BlurView(style: .systemThinMaterialDark))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
        .shadow(color: Color.black.opacity(0.45), radius: 10, x: 0, y: 6)
        .scaleEffect(show ? 1 : 0.85)
        .opacity(show ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) { show = true }
        }
        .onDisappear {
            show = false
        }
    }
}
