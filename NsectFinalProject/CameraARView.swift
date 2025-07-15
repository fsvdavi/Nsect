import SwiftUI

struct CameraARView: View {
    @StateObject private var arCoordinator = ARCoordinator()
    
    var body: some View {
        ZStack {
            ARViewContainerWrapper(coordinator: arCoordinator)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Button(action: {
                    arCoordinator.capturarCubo()
                }) {
                    Circle()
                        .fill(arCoordinator.canCapture ? Color.gray : Color.gray.opacity(0.1))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "camera.viewfinder")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                }
                .disabled(!arCoordinator.canCapture)
                .padding(.bottom, 40)
            }
        }
    }
}
