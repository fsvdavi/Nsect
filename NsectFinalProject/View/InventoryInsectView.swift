import SwiftUI

struct InventoryInsectView: View {
    let topBarHeight: CGFloat = 160

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Conteúdo da tela
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(1..<10) { index in
//                                MoldInsectView(id: index, nome: "Inseto \(index)", cor: .blue)
                            }
                        }
                        .padding(.top, topBarHeight + 10)
                        .padding(.horizontal)
                        .padding(.bottom, 100) // espaço para a tab bar
                    }

                    // Tab bar fixa
                    HStack(spacing: 0) {
                        // Home
                        VStack(spacing: 2) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 28))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)

                        // Camera (centralizado)
                        NavigationLink(destination: CameraARView()) {
                            VStack(spacing: 2) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 0.0, green: 0.4, blue: 0.2))
                                        .frame(width: 70, height: 70)

                                    Image(systemName: "camera")
                                        .foregroundColor(.white)
                                        .font(.system(size: 34))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: -20)
                        // Profile
                        NavigationLink(destination: InventoryInsectView()) {
                            VStack(spacing: 2) {
                                Image(systemName: "person.crop.circle")
                                    .font(.system(size: 32))
                            }
                            .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 1)
                    .padding(.horizontal, 16)
                    .background(
                        Color.white
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(radius: 3)
                    )
                    .padding(.bottom, 0)
                }

                // Barra superior verde com logo
                ZStack {
                    Rectangle()
                        .fill(Color(red: 0, green: 0.3, blue: 0))
                        .clipShape(RoundedCorners(radius: 20, corners: [.bottomLeft, .bottomRight]))

                    Image("nsectTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.horizontal, 16)
                        .padding(.top, 40)
                }
                .frame(height: topBarHeight)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
            }
            .ignoresSafeArea()
        }
    }
}
#Preview {
    InventoryInsectView()
}
