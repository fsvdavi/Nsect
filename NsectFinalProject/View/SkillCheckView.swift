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

    /// Token externo (o botão da câmera dispara isso)
    @Binding var externalTapToken: UUID

    // Ponteiro
    @State private var pointerX: CGFloat = 0
    @State private var direction: CGFloat = 1
    let barWidth: CGFloat = 250
    let speed: CGFloat = 3
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 10) {
            Spacer()

            Text("\(vm.currentStage)/\(vm.totalStages)")
                .font(.headline)

            ZStack(alignment: .leading) {
                // Barra base
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: barWidth, height: 20)

                // Zonas (verdes)
                ForEach(Array(vm.zones.enumerated()), id: \.offset) { pair in
                    let i = pair.offset
                    let z = pair.element
                    Capsule()
                        .fill(Color.green.opacity(vm.remainingZones.contains(i) ? 0.85 : 0.25))
                        .overlay(
                            Capsule().stroke(Color.black.opacity(0.35), lineWidth: 1)
                        )
                        .frame(width: barWidth * z.width, height: 20)
                        .offset(x: barWidth * z.start)
                }

                // Ponteiro
                Capsule()
                    .fill(Color.red)
                    .frame(width: 6, height: 28)
                    .offset(x: pointerX - 3)
            }
            .padding(.bottom, 150) // espaço para o botão que fica por cima
        }
        .background(Color.clear)
        .onAppear {
            vm.generateZones()
            startPointer()
        }
        .onDisappear {
            timer?.invalidate()
        }
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak vm] _ in
            // usa a view state (não a VM) pra animar o ponteiro
        }
        // Anima o ponteiro com outro timer para não capturar forte a VM
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            pointerX += speed * direction
            if pointerX <= 0 || pointerX >= barWidth {
                vm.stageFailed = true
                endStage()
                direction *= -1
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
}
