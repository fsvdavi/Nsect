import SwiftUI

// Mock para preview
final class PlayerProgressMock: ObservableObject {
    @Published var level: Int = 5
    @Published var xp: Int = 120
    @Published var unlockedRarities: [PlayerProgress.Rarity] = [.comum, .raro, .epico]

    func xpRequired(forLevel level: Int) -> Int {
        return 200
    }
}

struct PlayerProgressView: View {
    @ObservedObject var progress: PlayerProgressMock

    var body: some View {
        VStack(spacing: 16) {
            // Nível
            Text("Nível \(progress.level)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.green)

            // Barra de XP
            VStack(alignment: .leading, spacing: 6) {
                ProgressView(value: Double(progress.xp),
                             total: Double(progress.xpRequired(forLevel: progress.level)))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text("XP: \(progress.xp)/\(progress.xpRequired(forLevel: progress.level))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Raridades desbloqueadas
            VStack(spacing: 8) {
                Text("Raridades desbloqueadas:")
                    .font(.headline)
                HStack(spacing: 12) {
                    ForEach(progress.unlockedRarities, id: \.self) { rarity in
                        Text(rarity.rawValue)
                            .font(.caption)
                            .padding(6)
                            .background(Color.green.opacity(0.15))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
                .shadow(radius: 5)
        )
        .padding()
    }
}

// Preview usando o mock
struct PlayerProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerProgressView(progress: PlayerProgressMock())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.2))
    }
}
