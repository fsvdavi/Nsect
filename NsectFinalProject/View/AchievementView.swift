import SwiftUI

struct AchievementView: View {
    let achievement: Achievement

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    achievement.isUnlocked
                    ? AnyShapeStyle(LinearGradient(colors: [Color.green.opacity(0.8), Color.green], startPoint: .leading, endPoint: .trailing))
                    : AnyShapeStyle(Color.gray.opacity(0.4))
                )

            HStack {
                Image(systemName: achievement.isUnlocked ? "trophy" : "lock.fill")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 28))
                    .padding(.trailing, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(achievement.title)
                        .font(.system(size: 19))
                        .foregroundColor(.white)
                        .bold()
                    Text(achievement.description)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.9))
                }
                .blur(radius: achievement.isUnlocked ? 0 : 2)
                .opacity(achievement.isUnlocked ? 1 : 0.6)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 20) {
        AchievementView(achievement: Achievement(
            title: "Mestre dos Insetos",
            description: "Capture todos os artrópodes disponíveis",
            isUnlocked: true
        ))

        AchievementView(achievement: Achievement(
            title: "Explorador Iniciante",
            description: "Capture seu primeiro inseto",
            isUnlocked: false
        ))
    }
}

