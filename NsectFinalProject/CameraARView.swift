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
                        .fill(Color.white.opacity(0.8))
                        .frame(width: 70, height: 70)
                        .overlay(
                            Image(systemName: "camera.viewfinder")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        )
                }
                .padding(.bottom, 40)
            }
        }
    }
}
