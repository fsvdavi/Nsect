import SwiftUI
import RealityKit
import ARKit

// --------------------- SkillCheckViewModel ---------------------
class SkillCheckViewModel: ObservableObject {
    @Published var currentStage = 1
    let totalStages = 4
    @Published var hits = 0

    @Published var zones: [(start: CGFloat, width: CGFloat)] = []
    @Published var remainingZones: Set<Int> = []

    func generateZone() {
        zones.removeAll()
        remainingZones.removeAll()
        let width = CGFloat.random(in: 0.12...0.18)
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
        Double(hits) / Double(totalStages)
    }
}

// --------------------- SkillCheckView ---------------------
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

                // Bolinha verde com borda que acompanha
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
        // Velocidade aumentada
        let increment = barWidth / CGFloat(stageDuration / 0.015)

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            pointerX += increment
            if pointerX >= barWidth {
                // Se o tempo acabar sem clicar ou sem acerto, falha
                endStage(success: false)
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func handleTap() {
        let hit = vm.checkHit(pointerX: pointerX, barWidth: barWidth)
        if hit {
            // Clicou dentro da zona verde: sucesso
            endStage(success: true)
        } else {
            // Clicou fora: falha
            endStage(success: false)
        }
    }

    private func endStage(success: Bool) {
        timer?.invalidate()
        if success {
            vm.hits += 0 // hits já contado no checkHit
        }
        if vm.currentStage < vm.totalStages {
            vm.currentStage += 1
            startStage()
        } else {
            if vm.successRate() >= 0.75 {
                onSuccess()
            } else {
                onFail()
            }
            isPresented = false
        }
    }
}
