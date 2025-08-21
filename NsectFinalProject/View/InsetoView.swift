import SwiftUI
import SceneKit

struct InsetoDetailView: View {
    let artropode: Artropode
    let topBarHeight: CGFloat = 160
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
                    .padding(.bottom, -62)
                                        
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 1) {
                            HStack(alignment: .center, spacing: 12) {
                                // Badge com o ID
                                ZStack {
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.green.opacity(0.95), Color(red: 0.04, green: 0.35, blue: 0.12)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(minWidth: 72, maxWidth: 92, minHeight: 44, maxHeight: 44)
                                        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 4)

                                    Text("#\(String(format: "%02d", Int(artropode.id) ?? 0))")
                                        .font(.system(size: 16, weight: .black, design: .rounded))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .accessibilityLabel("ID do inseto")
                                }

                                // Título principal (nome popular) + nome científico menor
                                VStack(alignment: .leading, spacing: 4) {
                                    // Nome popular estilizado, com gradiente e contorno
                                    Text(artropode.nomePopular)
                                        .font(.system(size: 26, weight: .heavy, design: .serif))
                                        .foregroundStyle(
                                            LinearGradient(
                                                colors: [Color.white, Color(hue: 0.34, saturation: 0.6, brightness: 0.25)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .shadow(color: Color.black.opacity(0.35), radius: 6, x: 0, y: 3)
                                        .overlay( // contorno sutil (stroke)
                                            Text(artropode.nomePopular)
                                                .font(.system(size: 26, weight: .heavy, design: .serif))
                                                .foregroundColor(.clear)
                                                .shadow(color: Color.green.opacity(0.4), radius: 0, x: 0, y: 0)
                                                .mask(
                                                    Text(artropode.nomePopular)
                                                        .font(.system(size: 26, weight: .heavy, design: .serif))
                                                )
                                        )
                                        .lineLimit(1)
                                        .truncationMode(.tail)

                                    // Nome científico menor, itálico e elegante
                                    Text(artropode.nomeCientifico)
                                        .font(.system(size: 14, weight: .medium, design: .serif))
                                        .italic()
                                        .foregroundColor(Color.white.opacity(0.9))
                                        .padding(.vertical, 0)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }

                                Spacer()

                                // Pequeno ícone decorativo (folha) à direita
                                Image(systemName: "leaf.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color.white.opacity(0.9), Color.green.opacity(0.9)], startPoint: .top, endPoint: .bottom)
                                    )
                                    .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 2)
                            }
                            .padding(.horizontal)


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
                            .padding(.top, 30)
                            .padding(.horizontal)
                            
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

                                AsyncImage(url: URL(string: artropode.imagemURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let img):
                                        img
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 220)
                                            .clipped()
                                            .cornerRadius(50)
                                    case .failure:
                                        Color.gray
                                            .frame(height: 220)
                                            .cornerRadius(50)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                            .padding(.bottom, 30)
                            .padding(.horizontal)

                            Spacer()
                          
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
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [Color.white, Color.green.opacity(1.0)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                                            .padding(.top, 4)

                                        Text(artropode.nomeCientifico)
                                            .font(.system(size: 28, weight: .regular, design: .serif))
                                            .italic()
                                            .foregroundColor(.secondary)
                                            .kerning(1.2)
                                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                                            .overlay(
                                                Text(artropode.nomeCientifico)
                                                    .font(.system(size: 28, weight: .regular, design: .serif))
                                                    .italic()
                                                    .foregroundColor(.secondary)
                                                    .offset(x: 0.5, y: 0.5)
                                                    .blendMode(.multiply)
                                                    .opacity(0.3)
                                            )

                                        Text("Descrição:")
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [Color.white, Color.green.opacity(1.0)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                                            .padding(.top, 4)

                                        Text(artropode.descricao)
                                            .font(.system(size: 16, weight: .regular, design: .serif))
                                            .foregroundColor(.white)
                                            .padding(16)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                                    .blur(radius: 1)
                                            )
                                            .lineSpacing(5)

                                        Text("Curiosidade:")
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .foregroundStyle(
                                                LinearGradient(
                                                    colors: [Color.white, Color.green.opacity(1.0)],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                                            .padding(.top, 4)

                                        Text(artropode.curiosidade)
                                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.black.opacity(0.2))
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                            )
                                            .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                                            .lineSpacing(6)

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
                    
                }
                .ignoresSafeArea(edges: .bottom)

            }
            .backgroundMusic(.inventoryDetail)
        }
    }

struct InsetoImageView: View {
    let imageURL: String

    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}


    @ViewBuilder
func infoColumn(title: String, value: String) -> some View {
    VStack(alignment: .center, spacing: 7) {
        Text(title)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.green, Color.teal],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shadow(color: .black.opacity(1.0), radius: 2, x: 1, y: 1)
        Text(value)
            .font(.system(size: 16, weight: .medium, design: .serif))
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.25))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)

    }
}
    struct CustomSceneView: UIViewRepresentable {
        let named: String

        let insetoEscalas: [String: SIMD3<Float>] = [
            "ant": SIMD3<Float>(1.5, 1.5, 1.5),
            "spider": SIMD3<Float>(1.8, 1.8, 1.8),
            "RedAnt": SIMD3<Float>(1.8, 1.8, 1.8),
            "mantis": SIMD3<Float>(1.0, 1.0, 1.0),
            "besouro": SIMD3<Float>(2.0, 2.0, 2.0),
            "Scorpion": SIMD3<Float>(1.4, 1.4, 1.4),
            "Ladybug": SIMD3<Float>(1.4, 1.4, 1.4)
        ]
        
        func makeUIView(context: Context) -> SCNView {
            let scnView = SCNView()
            if let scene = SCNScene(named: named + ".scn") {
                scene.background.contents = UIColor.clear
                
                let scale = insetoEscalas[named] ?? SIMD3<Float>(0.05, 0.05, 0.05)
                scene.rootNode.scale = SCNVector3(scale.x, scale.y, scale.z)
                
                scnView.scene = scene
            }
            scnView.allowsCameraControl = true
            scnView.autoenablesDefaultLighting = true
            scnView.backgroundColor = .clear
            return scnView
        }
        
        func updateUIView(_ uiView: SCNView, context: Context) {}
    }

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
