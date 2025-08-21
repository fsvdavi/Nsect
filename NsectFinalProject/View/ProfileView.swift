import SwiftUI

struct ProfileView: View {
    let topBarHeight: CGFloat = 360
    @Binding var showCamera: Bool
    @ObservedObject var coordinator: ARCoordinator

    struct RoundedCorners: Shape {
        var radius: CGFloat = 25.0
        var corners: UIRectCorner = [.bottomLeft, .bottomRight]

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 0, green: 0.3, blue: 0))
                        .clipShape(RoundedCorners(radius: 40, corners: [.bottomLeft, .bottomRight]))

                    VStack(spacing: 12) {
                        Text("PROFILE")
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 150, height: 150)
                            .overlay(
                                Image("hatsunemikuprofile")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )

                        Text("Usuário")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 34)

                        Text("Conquistas")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(.top, 40)
                }
                .frame(height: topBarHeight)
                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                .ignoresSafeArea(edges: .top)
                .padding(.bottom, -10)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(coordinator.conquistas.sorted { $0.isUnlocked && !$1.isUnlocked }) { achievement in
                            AchievementView(achievement: achievement)
                        }

                    }
                    .padding(.top, 10)
                    .padding(.bottom, 0)
                }
            }
        }
    }
}


