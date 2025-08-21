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
    @State private var isPressed = false

    
    @State private var pointerX: CGFloat = 0
    @State private var direction: CGFloat = 1
    let barWidth: CGFloat = 250
    let speed: CGFloat = 3
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Spacer().frame(height: 150)
            Text("\(vm.currentStage)/\(vm.totalStages)")
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: barWidth, height: 20)
                
                ForEach(vm.zones.indices, id: \.self) { i in
                    let z = vm.zones[i]
                    Rectangle()
                        .fill(.white.opacity(vm.remainingZones.contains(i) ? 0.6 : 0.2)) // zona já clicada fica fraca
                        .frame(width: barWidth * z.width, height: 20)
                        .offset(x: barWidth * z.start)
                }
                
                Rectangle()
                    .fill(.red)
                    .frame(width: 3, height: 30)
                    .offset(x: pointerX)
            }
            
            Button(action: {
                let acerto = vm.checkHit(pointerX, barWidth: barWidth)
                
                if acerto && vm.remainingZones.isEmpty {
                    // completou a etapa com sucesso
                    vm.hits += 1
                    endStage()
                } else if !acerto {
                    // erro → etapa falha imediatamente
                    endStage()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 80, height: 80)
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.top, 80)
        }
        .onAppear {
            vm.generateZones()
            startPointer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    // MARK: - Controle de etapas
    
    private func endStage() {
        timer?.invalidate()
        
        if vm.currentStage < vm.totalStages {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                vm.currentStage += 1
                vm.generateZones()
                startPointer()
            }
        } else {
            if vm.successRate() >= 0.75 { onSuccess() }
            else { onFail() }
            isPresented = false
        }
    }
    
    private func startPointer() {
        pointerX = 0
        direction = 1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            pointerX += speed * direction
            if pointerX <= 0 || pointerX >= barWidth {
                // se o ponteiro atravessar a barra → etapa falha
                vm.stageFailed = true
                endStage()
            }
            if pointerX <= 0 || pointerX >= barWidth {
                direction *= -1
            }
        }
    }
}


struct SkillCheckView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var isPresented = true
        
        var body: some View {
            SkillCheckView(
                vm: SkillCheckViewModel(),
                isPresented: $isPresented,
                onSuccess: { print("✅ Sucesso na skill check (Preview)") },
                onFail: { print("❌ Falhou na skill check (Preview)") }
            )
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
