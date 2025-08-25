//
//  SkillCheckView.swift
//  NsectFinalProject
//
//  Created by found on 21/08/25.
//

//
//  SkillCheckView.swift
//  NsectFinalProject
//
//  Created by found on 21/08/25.
//

import SwiftUI

struct SkillCheckView: View {
    @ObservedObject var vm = SkillCheckViewModel()
    @Binding var isPresented: Bool
    var onSuccess: () -> Void
    var onFail: () -> Void

    /// Token externo para "apertar" o skill usando o botão da câmera
    @Binding var externalTapToken: UUID

    // Ponteiro
    @State private var pointerX: CGFloat = 0
    @State private var direction: CGFloat = 1
    let barWidth: CGFloat = 250
    let speed: CGFloat = 3
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Spacer() // empurra para baixo

            Text("\(vm.currentStage)/\(vm.totalStages)")
                .font(.headline)
                .padding(.bottom, 8)

            // Barra + zonas
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.25))   // faixa visível sobre a câmera
                    .frame(width: barWidth, height: 20)

                ForEach(vm.zones.indices, id: \.self) { i in
                    let z = vm.zones[i]
                    Capsule()
                        .fill(Color.white.opacity(vm.remainingZones.contains(i) ? 0.9 : 0.25))
                        .overlay(Capsule().stroke(Color.black.opacity(0.35), lineWidth: 1))
                        .frame(width: barWidth * z.width, height: 20)
                        .offset(x: barWidth * z.start)
                }

                Capsule()
                    .fill(Color.red)
                    .frame(width: 6, height: 28)
                    .offset(x: pointerX - 3) // centra o ponteiro
            }
            .padding(.bottom, 150) // deixa espaço para o botão de capturar (que fica por cima)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)   // totalmente transparente
        .onAppear {
            vm.generateZones()
            startPointer()
        }
        .onDisappear {
            timer?.invalidate()
        }
        // Quando o botão de capturar for pressionado, este token muda e disparamos a checagem
        .onChange(of: externalTapToken) { _ in
            handleTap()
        }
    }

    private func handleTap() {
        let acerto = vm.checkHit(pointerX, barWidth: barWidth)

        if acerto && vm.remainingZones.isEmpty {
            vm.hits += 1
            endStage()
        } else if !acerto {
            endStage()
        }
    }

    private func endStage() {
        timer?.invalidate()
        if vm.currentStage < vm.totalStages {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                vm.currentStage += 1
                vm.generateZones()
                startPointer()
            }
        } else {
            if vm.successRate() >= 0.75 { onSuccess() } else { onFail() }
            isPresented = false
        }
    }

    private func startPointer() {
        pointerX = 0
        direction = 1
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            pointerX += speed * direction
            if pointerX <= 0 || pointerX >= barWidth {
                vm.stageFailed = true
                endStage()
                direction *= -1
            }
        }
    }
}
