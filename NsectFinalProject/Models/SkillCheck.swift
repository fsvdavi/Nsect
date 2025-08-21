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
    @Published var zones: [(start: CGFloat, width: CGFloat)] = []
    
    // NOVO: zonas restantes a serem clicadas na etapa
    @Published var remainingZones: Set<Int> = []
    @Published var stageFailed = false
    
    func generateZones() {
        zones.removeAll()
        let width = CGFloat.random(in: 0.12...0.18)
        let start = CGFloat.random(in: 0.15...(0.75 - width))
        zones.append((start, width))
        
        if Bool.random() {
            let s2 = CGFloat.random(in: 0.15...(0.75 - width))
            
            let primeira = zones[0]
            let fimPrimeira = primeira.0 + primeira.1
            let fimSegunda = s2 + width
            
            if fimSegunda < primeira.0 || s2 > fimPrimeira {
                zones.append((s2, width))
            }
        }
        
        // registra zonas que ainda precisam ser clicadas
        remainingZones = Set(0..<zones.count)
        stageFailed = false
    }
    
    /// Retorna se acertou uma zona
    func checkHit(_ pointerX: CGFloat, barWidth: CGFloat) -> Bool {
        for (i, z) in zones.enumerated() where remainingZones.contains(i) {
            let minX = barWidth * z.start
            let maxX = barWidth * (z.start + z.width)
            if pointerX >= minX && pointerX <= maxX {
                remainingZones.remove(i)
                return true
            }
        }
        stageFailed = true // clicou fora
        return false
    }
    
    func successRate() -> Double {
        Double(hits) / Double(totalStages)
    }
}
