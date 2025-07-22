import SwiftUI
import SceneKit


struct MoldInsectView: View {
    var insect: Artropode

    var body: some View {
        VStack(spacing: 0) {
            // 3D model view at the top
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.6), Color.green]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 220)
                
                CustomSceneView(named: insect.modelo3d)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
            }
            .frame(height: 130)
            .padding(.top, 20)

            // Dark gray bottom bar with ID and name
            HStack {
                Text("\(insect.id): \(insect.nomePopular)")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(height: 50)
            .background(Color(white: 0.4))
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 110/255, green: 194/255, blue: 99/255),
                Color(red: 101/255, green: 177/255, blue: 91/255)
            ]), startPoint: .top, endPoint: .bottom)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
    struct CustomSceneView: UIViewRepresentable {
        let named: String
        
        func makeUIView(context: Context) -> SCNView {
            let scnView = SCNView()
            if let scene = SCNScene(named: named + ".scn") {
                scene.background.contents = UIColor.clear
                scnView.scene = scene
            }
            scnView.allowsCameraControl = false
            scnView.autoenablesDefaultLighting = true
            scnView.backgroundColor = .clear
            return scnView
        }
        
        func updateUIView(_ uiView: SCNView, context: Context) {}
    }
}

#Preview {
    let insetoExemplo = Artropode(
        classe: "Insecta",
        nomeCientifico: "Formica fusca",
        nomePopular: "Formiga Negra",
        habitat: "Solo e folhas",
        descricao: "Uma formiga comum encontrada em diversos habitats.",
        curiosidade: "É capaz de levantar várias vezes seu próprio peso.",
        tamanho: "0.5 cm",
        peso: "0.003 g",
        imagemURL: "",
        modelo3d: "ant", // ou ant.scn, dependendo do seu asset
        id: "01"
    )

    return MoldInsectView(insect: insetoExemplo)
}
