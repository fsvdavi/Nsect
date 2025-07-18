import SwiftUI
import SceneKit
import RealityKit

struct InsetoDetailView: View {
    let artropode: Artropode

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGray6).ignoresSafeArea()

            // Header
            VStack(spacing: 0) {
                ZStack {
                    // Fundo verde com cantos arredondados inferior
                    RoundedCorner(radius: 30, corners: [.bottomLeft, .bottomRight])
                        .fill(Color.green)
                        .frame(height: 180)

                    // Logo
                    Text("Nsect")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .overlay(
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 50)
                )

                Spacer()
            }

            // Conteúdo
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(String(format: "#%02d", 5))
                            .font(.title2).fontWeight(.bold)
                            .foregroundColor(Color.green)
                        Spacer()
                        Text(artropode.nomePopular.capitalized)
                            .font(.title2).fontWeight(.bold)
                    }
                    .padding(.horizontal)

                    // Card da imagem 3D
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.green.opacity(0.6), Color.green]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 200)

                        // Usando SceneView para exibir .usdz
                        SceneView(
                            scene: SCNScene(named: artropode.modelo3d
                                .components(separatedBy: "/").last!),
                            options: [.autoenablesDefaultLighting, .allowsCameraControl]
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 180)
                    }
                    .padding(.horizontal)

                    // Grid de informações
                    VStack {
                        HStack {
                            infoColumn(title: "Tamanho", value: artropode.tamanho)
                            Spacer()
                            infoColumn(title: "Peso", value: artropode.peso)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)

                        HStack {
                            infoColumn(title: "Classe", value: artropode.classe)
                            Spacer()
                            infoColumn(title: "Habitat", value: artropode.habitat)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)
                    .padding(.horizontal)

                    Spacer(minLength: 100)
                }
                .padding(.top, 200)
            }

            // Botão flutuante + e Tab Bar
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    Spacer()
                }
                .offset(y: -30)

                HStack {
                    Spacer()
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                    Spacer()
                    Spacer()
                    Image(systemName: "ellipsis.bubble")
                        .font(.title2)
                        .foregroundColor(.green)
                    Spacer()
                }
                .padding(.vertical, 10)
                .background(Color.white.shadow(radius: 2))
            }
        }
    }

    // Helper para colunas info
    @ViewBuilder
    func infoColumn(title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// Shape de cantos seletivos
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Preview com carregarArtrópodes
struct InsetoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        if let first = carregarArtrópodes().first {
            InsetoDetailView(artropode: first)
        } else {
            Text("Nenhum inseto disponível")
        }
    }
}
