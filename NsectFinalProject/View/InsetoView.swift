import SwiftUI
import SceneKit

struct InsetoDetailView: View {
    let artropode: Artropode
    let topBarHeight: CGFloat = 160
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Fundo da tela
                Image("forestBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .opacity(0.8)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // TopBar com canto arredondado e "Nsect"
                    ZStack {
                        Rectangle()
                            .fill(Color(red: 0, green: 0.3, blue: 0))
                            .clipShape(RoundedCorners(radius: 20, corners: [.bottomLeft, .bottomRight]))
                        
                        VStack {
                            Image("nsectTitle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 90)
                                .padding(.top, 40)
                        }
                    }
                    .frame(height: topBarHeight)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
                    .ignoresSafeArea(edges: .top)
                    .padding(.bottom, 10)
                    
                    // Agora continua com ScrollView normalmente
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .firstTextBaseline, spacing: 140) {  // diminui o spacing do HStack
                                Text("#0\(artropode.id)")
                                    .font(.system(size: 25))
                                    .fontWeight(.bold)
                                    .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }

                                Text(artropode.nomePopular)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, -60)


                            // Card com modelo 3D sem fundo branco
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
                                
                                CustomSceneView(named: artropode.modelo3d)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 300)
                            }
                            .padding(.horizontal)
                            
                            // Informações
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
                        .padding(.top, 20)
                    }
                    
                    tabBar
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
    
    var tabBar: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: HomeView()) {
                VStack(spacing: 2) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 28))
                }
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
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
            
//            NavigationLink(destination: InventoryInsectView()) {
                VStack(spacing: 2) {
                    Image(systemName: "person.crop.circle")
                        .font(.system(size: 32))
                }
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
//        .padding(.vertical, 1)
//        .padding(.horizontal, 16)
//        .background(
//            Color.white
//                .clipShape(RoundedRectangle(cornerRadius: 25))
//                .shadow(radius: 3)
//        )
    }
    
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
    struct CustomSceneView: UIViewRepresentable {
        let named: String
        
        func makeUIView(context: Context) -> SCNView {
            let scnView = SCNView()
            if let scene = SCNScene(named: named + ".scn") {
                scene.background.contents = UIColor.clear
                scnView.scene = scene
            }
            scnView.allowsCameraControl = true
            scnView.autoenablesDefaultLighting = true
            scnView.backgroundColor = .clear
            return scnView
        }
        
        func updateUIView(_ uiView: SCNView, context: Context) {}
    }
    // Preview com carregarArtropodes
    struct InsetoDetailView_Previews: PreviewProvider {
        static var previews: some View {
            let artrópodes = carregarArtropodes()
            
            if artrópodes.indices.contains(4) {
                InsetoDetailView(artropode: artrópodes[4])
            } else {
                Text("Nenhum inseto disponível")
            }
        }
    }
//}
