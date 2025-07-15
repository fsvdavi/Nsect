import SwiftUI

struct CameraARView: View {
    @StateObject private var arCoordinator = ARCoordinator()
    
    var body: some View {
        ZStack {
            ARViewContainerWrapper(coordinator: arCoordinator)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let mensagem = arCoordinator.mensagem {
                    Text(mensagem)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(red: 0.0, green: 0.3, blue: 0.0).opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.top, 20)
                        .transition(.opacity)
                        .animation(.easeInOut, value: mensagem)
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Button(action: {
                    arCoordinator.capturarNsect()
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
