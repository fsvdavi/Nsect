import SwiftUI
import RealityKit
import SceneKit

struct MoldInsectView: View {
    var id: Int
    var nome: String
    var cor: Color
    let artropode: Artropode

    var body: some View {
        VStack(spacing: 16) {
            // Ícone do inseto circular no topo
            SceneView(
                scene: SCNScene(named: "\(artropode.modelo3d).scn"
                    .components(separatedBy: "/").last!),
                options: [.autoenablesDefaultLighting, .allowsCameraControl]
            )
            .aspectRatio(contentMode: .fit)
            .frame(height: 180)
        }

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .frame(width: 160, height: 35)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .overlay {
                        HStack(spacing: 20) {
                            Text("#\(String(format: "%02d", id))")
                                .font(.system(size: 14, weight: .bold))
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.leading, 12)

                            Text(nome)
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()
                        }
                    }
                    .offset(y: -10)             }
        }


#Preview {
    let inseto = Artropode(
        classe: "Insecta",
        nomeCientifico: "Dynastes hercules",
        nomePopular: "Besouro-Hércules",
        habitat: "Florestas tropicais",
        descricao: "Um dos maiores besouros do mundo, com chifres impressionantes.",
        curiosidade: "Pode levantar até 850 vezes o seu próprio peso.",
        tamanho: "17 cm",
        peso: "100 g",
        imagemURL: "",
        modelo3d: "besouro_hercules",
        id: "01"
    )
    MoldInsectView(id: 1, nome: "Besouro-Hércules", cor: .green, artropode: inseto)
}

