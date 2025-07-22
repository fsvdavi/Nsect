import SwiftUI
import SceneKit
import RealityKit

struct InsetoDetailView: View {
    let artropode: Artropode
    let topBarHeight: CGFloat = 160

    var body: some View {
        ZStack(alignment: .top) {
            Color(.systemGray6).ignoresSafeArea()

            // Header
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
            .ignoresSafeArea(edges: .top)
            .padding(.bottom, 10)


            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("#0\(artropode.id)")
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
                            scene: SCNScene(named: "\(artropode.modelo3d).scn"
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

                        VStack(alignment: .leading, spacing: 12) {
                            Group {
                                Text("Nome científico:")
                                    .font(.headline)
                                Text(artropode.nomeCientifico)
                                    .font(.body)
                                    .foregroundColor(.secondary)

                                Text("Descrição:")
                                    .font(.headline)
                                    .padding(.top, 4)
                                Text(artropode.descricao)
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Text("Curiosidade:")
                                    .font(.headline)
                                    .padding(.top, 4)
                                Text(artropode.curiosidade)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal)
                        }
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


// Preview com carregarArtrópodes
struct InsetoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let artrópodes = carregarArtropodes()
        
        if artrópodes.indices.contains(3) {
            InsetoDetailView(artropode: artrópodes[3])
        } else {
            Text("Nenhum inseto disponível")
        }
    }
}
