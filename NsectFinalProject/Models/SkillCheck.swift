import SwiftUI

struct SkillCheckView: View {
    @ObservedObject var vm: SkillCheckViewModel
    @Binding var isPresented: Bool
    var onSuccess: () -> Void
    var onFail: () -> Void
    @Binding var externalTapToken: UUID

    @State private var pointerX: CGFloat = 0
    let barWidth: CGFloat = 250
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
                            Capsule().fill(Color.green.opacity(0.85))
                            Capsule().stroke(Color.black.opacity(0.3), lineWidth: 1)
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
        // calcula incremento com base em stageDuration e tickInterval do VM
        let steps = max(1, vm.stageDuration / vm.tickInterval)
        let increment = barWidth / CGFloat(steps)

        timer = Timer.scheduledTimer(withTimeInterval: vm.tickInterval, repeats: true) { _ in
            pointerX += increment
            if pointerX >= barWidth {
                endStage(success: false)
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func handleTap() {
        let hit = vm.checkHit(pointerX: pointerX, barWidth: barWidth)
        endStage(success: hit)
    }

    private func endStage(success: Bool) {
        timer?.invalidate()
        if success {
            // hits já incrementado em checkHit
        }
        if vm.currentStage < vm.totalStages {
            vm.currentStage += 1
            startStage()
        } else {
            // avaliar com a taxa requerida definida no VM
            if vm.successRate() >= vm.requiredSuccessRate {
                onSuccess()
            } else {
                onFail()
            }
            isPresented = false
        }
    }
}
