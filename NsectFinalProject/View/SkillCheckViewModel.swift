//
//  SkillCheckViewModel.swift
//  NsectFinalProject
//
//  Created by found on 28/08/25.
//


import SwiftUI

class SkillCheckViewModel: ObservableObject {
    // MARK: - Estado público
    @Published var currentStage: Int = 1
    @Published var totalStages: Int = 4
    @Published var hits: Int = 0

    @Published var zones: [(start: CGFloat, width: CGFloat)] = []
    @Published var remainingZones: Set<Int> = []

    // Parâmetros de dificuldade (configuráveis)
    var stageDuration: TimeInterval = 3.0           // segundos por etapa
    var zoneWidthRange: ClosedRange<CGFloat> = 0.12...0.18
    var requiredSuccessRate: Double = 0.75          // % mínimo de acertos para sucesso final
    var tickInterval: TimeInterval = 0.01           // precisão do timer

    // MARK: - Configuração por raridade
    func configure(for rarityString: String) {
        let folded = rarityString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()

        switch folded {
        case "comum", "common":
            applyParameters(total: 3, duration: 3.2, zoneRange: 0.16...0.22, requiredRate: 0.6)
        case "raro", "rare":
            applyParameters(total: 4, duration: 3.0, zoneRange: 0.12...0.18, requiredRate: 0.75)
        case "epico", "épico", "epic":
            applyParameters(total: 5, duration: 2.6, zoneRange: 0.09...0.14, requiredRate: 0.80)
        case "lendario", "lendário", "legendary":
            applyParameters(total: 6, duration: 2.2, zoneRange: 0.07...0.11, requiredRate: 0.85)
        case "secret", "secreto":
            applyParameters(total: 7, duration: 1.6, zoneRange: 0.05...0.09, requiredRate: 0.90)
        default:
            // fallback: comportamento médio (como "raro")
            applyParameters(total: 4, duration: 3.0, zoneRange: 0.12...0.18, requiredRate: 0.75)
        }
    }

    // Caso você queira configurar com o enum PlayerProgress.Rarity
    func configure(for rarity: PlayerProgress.Rarity) {
        switch rarity {
        case .comum: applyParameters(total: 3, duration: 3.2, zoneRange: 0.16...0.22, requiredRate: 0.6)
        case .raro: applyParameters(total: 4, duration: 3.0, zoneRange: 0.12...0.18, requiredRate: 0.75)
        case .epico: applyParameters(total: 5, duration: 2.6, zoneRange: 0.09...0.14, requiredRate: 0.80)
        case .lendario: applyParameters(total: 6, duration: 2.2, zoneRange: 0.07...0.11, requiredRate: 0.85)
        case .secret: applyParameters(total: 7, duration: 1.6, zoneRange: 0.05...0.09, requiredRate: 0.90)
        }
    }

    private func applyParameters(total: Int, duration: TimeInterval, zoneRange: ClosedRange<CGFloat>, requiredRate: Double) {
        self.totalStages = max(1, total)
        self.stageDuration = duration
        self.zoneWidthRange = zoneRange
        self.requiredSuccessRate = requiredRate
        self.currentStage = 1
        self.hits = 0
        self.zones.removeAll()
        self.remainingZones.removeAll()
    }

    // MARK: - Zona / checagem
    func generateZone() {
        zones.removeAll()
        remainingZones.removeAll()
        let width = CGFloat.random(in: zoneWidthRange)
        let start = CGFloat.random(in: 0.02...(0.98 - width))
        zones.append((start: start, width: width))
        remainingZones.insert(0)
    }

    func checkHit(pointerX: CGFloat, barWidth: CGFloat) -> Bool {
        guard let i = remainingZones.first else { return false }
        let z = zones[i]
        let minX = barWidth * z.start
        let maxX = barWidth * (z.start + z.width)

        if pointerX >= minX && pointerX <= maxX {
            remainingZones.remove(i)
            hits += 1
            return true
        }
        return false
    }

    func successRate() -> Double {
        guard totalStages > 0 else { return 0.0 }
        return Double(hits) / Double(totalStages)
    }
}
