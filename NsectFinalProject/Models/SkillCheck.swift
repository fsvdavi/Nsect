//
//  SkillCheck.swift
//  NsectFinalProject
//
//  Created by found on 21/08/25.
//

import SwiftUI

class SkillCheckViewModel: ObservableObject {
    @Published var currentStage = 1
    let totalStages = 4
    @Published var hits = 0

    // [0,1] relativo à largura da barra (start = posição, width = largura)
    @Published var zones: [(start: CGFloat, width: CGFloat)] = []

    // zonas ainda não clicadas na etapa
    @Published var remainingZones: Set<Int> = []
    @Published var stageFailed = false

    func generateZones() {
        zones.removeAll()

        // 1 ou 2 zonas, SEM sobrepor
        let count = Bool.random() ? 2 : 1
        var temp: [(CGFloat, CGFloat)] = []

        for _ in 0..<count {
            let w = CGFloat.random(in: 0.12...0.18)
            var placed = false
            var tries = 0
            while !placed, tries < 12 {
                // permite ocupar praticamente toda a barra
                let s = CGFloat.random(in: 0.02...(0.98 - w))
                let r1 = s...(s + w)
                let overlap = temp.contains { (s2, w2) in
                    let r2 = s2...(s2 + w2)
                    return r1.overlaps(r2)
                }
                if !overlap { temp.append((s, w)); placed = true }
                tries += 1
            }
        }

        // fallback: garante pelo menos uma zona visível
        if temp.isEmpty { temp = [(0.42, 0.15)] }

        zones = temp
        remainingZones = Set(0..<zones.count)
        stageFailed = false
    }

    /// Retorna se o ponteiro está dentro de alguma zona ainda válida
    func checkHit(_ pointerX: CGFloat, barWidth: CGFloat) -> Bool {
        for (i, z) in zones.enumerated() where remainingZones.contains(i) {
            let minX = barWidth * z.start
            let maxX = barWidth * (z.start + z.width)
            if pointerX >= minX && pointerX <= maxX {
                remainingZones.remove(i)
                return true
            }
        }
        stageFailed = true
        return false
    }

    func successRate() -> Double {
        Double(hits) / Double(totalStages)
    }
}
