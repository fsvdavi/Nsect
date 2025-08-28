import SwiftUI
import RealityKit
import ARKit

struct SkillCheckView: View {
    @ObservedObject var vm: SkillCheckViewModel
    @Binding var isPresented: Bool
    var onSuccess: () -> Void
    var onFail: () -> Void
    @Binding var externalTapToken: UUID

    @State private var pointerX: CGFloat = 0
    let barWidth: CGFloat = 250
    let stageDuration: TimeInterval = 3.0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Etapa \(vm.currentStage)/\(vm.totalStages)")
                .font(.headline)

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: barWidth, height: 20)

                ForEach(Array(vm.zones.enumerated()), id: \.offset) { i, z in
                    if vm.remainingZones.contains(i) {
                        ZStack {
                            Capsule()
                                .fill(Color.green.opacity(0.85))
                            Capsule()
                                .stroke(Color.black.opacity(0.3), lineWidth: 1)
                        }
                        .frame(width: barWidth * z.width, height: 20)
                        .offset(x: barWidth * z.start)
                    }
                }

                Capsule()
                    .fill(Color.red)
                    .frame(width: 6, height: 28)
                    .offset(x: pointerX - 3)
            }
            .padding(.bottom, 150)
        }
        .onAppear { startStage() }
        .onDisappear { timer?.invalidate() }
        .onChange(of: externalTapToken) { _, _ in handleTap() }
    }

    private func startStage() {
        pointerX = 0
        vm.generateZone()

        timer?.invalidate()
        let increment = barWidth / CGFloat(stageDuration / 0.015)

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            pointerX += increment
            if pointerX >= barWidth {
                endStage(success: false)
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func handleTap() {
        let hit = vm.checkHit(pointerX: pointerX, barWidth: barWidth)
        
        if hit {
            SoundEffectsManager.shared.play("acerto")
            endStage(success: true)
        } else {
            SoundEffectsManager.shared.play("erro")
            endStage(success: false)
        }
    }

    private func endStage(success: Bool) {
        timer?.invalidate()
        
        if vm.currentStage < vm.totalStages {
            vm.currentStage += 1
            startStage()
        } else {
            if vm.successRate() >= 0.75 {
                SoundEffectsManager.shared.play("acerto") // som final de sucesso
                onSuccess()
            } else {
                SoundEffectsManager.shared.play("erro") // som final de falha
                onFail()
            }
            isPresented = false
        }
    }
}
