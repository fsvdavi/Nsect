import SwiftUI

struct HomeView: View {
    let topBarHeight: CGFloat = 160

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.leading, 8)

                        Spacer()

                        Circle()
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 70, height: 70)
                            .overlay(
                                Circle().stroke(Color.black, lineWidth: 2)
                            )
                            .padding(.trailing, 24)
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .padding(.top, 10)

                    Spacer()

                    // Retângulos empilhados como NavigationLink
                    VStack(spacing: 16) {
                        // Retângulo 1 → CameraARView
                        NavigationLink {
                            CameraARView(arCoordinator: ARCoordinator())
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.5))
                                    .frame(height: 70)
                                    .frame(width: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                Text("Abrir Câmera AR")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.plain)

                        // Retângulo 2 → InventoryInsectView
                        NavigationLink {
                            InventoryInsectView(arCoordinator: ARCoordinator())
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.5))
                                    .frame(height: 70)
                                    .frame(width: 300)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                Text("Abrir Inventário")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 80)
                }
            }
        }
    }
}

