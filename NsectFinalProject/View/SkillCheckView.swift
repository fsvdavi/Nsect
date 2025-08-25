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

    @Binding var externalTapToken: UUID

    @State private var pointerX: CGFloat = 0
    @State private var direction: CGFloat = 1
    let barWidth: CGFloat = 250
    let speed: CGFloat = 3
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Spacer()
            
            Text("\(vm.currentStage)/\(vm.totalStages)")
                .font(.headline)
                .padding(.bottom, 8)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: barWidth, height: 20)

                ForEach(vm.zones.indices, id: \.self) { i in
                    let z = vm.zones[i]
                    Capsule()
                        .fill(Color.green.opacity(vm.remainingZones.contains(i) ? 0.9 : 0.25))
                        .overlay(Capsule().stroke(Color.black.opacity(0.35), lineWidth: 1))
                        .frame(width: barWidth * z.width, height: 20)
                        .offset(x: barWidth * z.start)
                }

                Capsule()
                    .fill(Color.red)
                    .frame(width: 6, height: 28)
                    .offset(x: pointerX - 3)
            }
            .padding(.bottom, 150)
        }
        .background(Color.clear) // transparente
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
