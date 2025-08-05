import SwiftUI
import SceneKit

struct MoldInsectView: View {
    var insect: Artropode

    var body: some View {
        VStack(spacing: 16) {
            CuuustomSceneView(named: insect.modelo3d)
                .aspectRatio(contentMode: .fit)
                .frame(width: 500, height: 250)
                .offset(y: 150)
                .zIndex(1)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color(red: 0, green: 0.4, blue: 0)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 180, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .frame(width: 180, height: 35) 
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .overlay {
                        HStack(spacing: 8) {
                            Text("#0\(insect.id)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .padding(.leading, 12)

                            Text(insect.nomePopular)
                                .font(.headline)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)

                            Spacer()
                        }
                    }
                    .offset(y: -10)
            }
            .frame(height: 120 + 25)
        }
        .frame(width: 180, height: 200)
    }
}

struct CuuustomSceneView: UIViewRepresentable {
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
        scnView.isUserInteractionEnabled = false
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}

struct InsectetailView_Previews: PreviewProvider {
    static var previews: some View {
        let artrópodes = carregarArtropodes()
        
        if artrópodes.indices.contains(6) {
            MoldInsectView(insect: artrópodes[6])
        } else {
            Text("Nenhum inseto disponível")
        }
    }
}
