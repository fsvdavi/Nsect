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
            // Background
            Image("background")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Bar
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
                        
                        // ID + Nomes
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
                            
                            // Nome Popular + Científico + Raridade (ADICIONADO)
                            VStack(alignment: .leading, spacing: 6) {
                                Text(artropode.nomePopular)
                                    .font(.system(size: 26, weight: .heavy, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color(hue: 0.34, saturation: 0.6, brightness: 0.75)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: Color.black.opacity(0.35), radius: 6, x: 0, y: 3)
                                    .overlay(
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
                                
                                Text(artropode.nomeCientifico)
                                    .font(.system(size: 14, weight: .medium, design: .serif))
                                    .italic()
                                    .foregroundColor(Color.white.opacity(0.9))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                // Raridade exibida de forma elegante (ADICIONADO)
                                
                            }
                            
                            Spacer()
                            
                            // Ícone decorativo
                         
                        }
                        .padding(.horizontal)
                        
                        // Modelo 3D
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.black.opacity(0.4), Color.gray]),
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
                        
                        // Imagem do inseto
                        ZStack {
                            RoundedRectangle(cornerRadius: 50)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.gray.opacity(0.6), Color.green]),
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
                        
                        // Informações gerais
                        VStack {
                            HStack(spacing: 8) {
                                Image(systemName: iconName(for: artropode.raridade))
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(colorForRarity(artropode.raridade))
                                Text(artropode.raridade)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(rarityBackgroundGradient(for: artropode.raridade))
                                    .opacity(0.95)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                            
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
                        
                        // Detalhes e curiosidades
                        VStack(alignment: .leading, spacing: 12) {
                            
                            
                            
                            Group {
                                Text("Nome científico:")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color.white, Color.green.opacity(1.0)], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                                    .padding(.top, 4)
                                
                                Text(artropode.nomeCientifico)
                                    .font(.system(size: 28, weight: .regular, design: .serif))
                                    .italic()
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.7), radius: 2, x: 1, y: 1)
                                    .overlay(
                                        Text(artropode.nomeCientifico)
                                            .font(.system(size: 28, weight: .regular, design: .serif))
                                            .italic()
                                            .foregroundColor(.white.opacity(0.9))
                                            .offset(x: 0.5, y: 0.5)
                                    )
                                
                                Text("Descrição:")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(colors: [Color.white, Color.green.opacity(1.0)], startPoint: .leading, endPoint: .trailing)
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
                                                    gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.green.opacity(0.6)]),
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
                                        LinearGradient(colors: [Color.white, Color.green.opacity(1.0)], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .shadow(color: .black.opacity(0.4), radius: 2, x: 1, y: 1)
                                    .padding(.top, 4)
                                
                                Text(artropode.curiosidade)
                                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.2)))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(0.6), lineWidth: 1))
                                    .shadow(color: .black.opacity(0.4), radius: 4, x: 2, y: 2)
                                    .lineSpacing(6)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 16)
                        
                    }
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.6), Color.gray.opacity(0.6)]),
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
        .backgroundMusic(.inventoryDetail)
    }
}

// MARK: - Subcomponentes

struct InsetoImageView: View {
    let imageURL: String
    
    var body: some View {
        AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
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
                LinearGradient(colors: [Color.green, Color.teal], startPoint: .leading, endPoint: .trailing)
            )
            .shadow(color: .black.opacity(1.0), radius: 2, x: 1, y: 1)
        
        Text(value)
            .font(.system(size: 16, weight: .medium, design: .serif))
            .foregroundColor(.white)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.black.opacity(0.25)))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 1))
            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
    }
}

// MARK: - 3D Scene View
struct CustomSceneView: UIViewRepresentable {
    let named: String

    // Mapeamento de escala para cada modelo (ajuste conforme necessário)
    let insetoEscalas: [String: SIMD3<Float>] = [
        // comuns já mapeados
        "ant": SIMD3<Float>(1.5, 1.5, 1.5),
        "spider": SIMD3<Float>(1.8, 1.8, 1.8),
        "RedAnt": SIMD3<Float>(1.8, 1.8, 1.8),
        "mantis": SIMD3<Float>(1.0, 1.0, 1.0),
        "besouro": SIMD3<Float>(2.0, 2.0, 2.0),
        "Scorpion": SIMD3<Float>(1.4, 1.4, 1.4),
        "Ladybug": SIMD3<Float>(1.4, 1.4, 1.4),
        "AbelhaCarpinteira": SIMD3<Float>(1.2, 1.2, 1.2),
        "AranhaPavão": SIMD3<Float>(1.6, 1.6, 1.6),
        "BesouroBomba": SIMD3<Float>(1.1, 1.1, 1.1),
        "Bicho-pau": SIMD3<Float>(1.4, 1.4, 1.4),
        "EscorpiaoCaudaChicote": SIMD3<Float>(1.3, 1.3, 1.3),
        "FormigaLeão": SIMD3<Float>(1.2, 1.2, 1.2),
        "gorgulhoGirafa": SIMD3<Float>(1.1, 1.1, 1.1),
        "HatsuneMiku": SIMD3<Float>(1.0, 1.0, 1.0), // costuma ser muito grande — escala pequena
        "jewelSpiderglb": SIMD3<Float>(1.5, 1.5, 1.5),
        "Kuromi": SIMD3<Float>(0.9, 0.9, 0.9),
        "LouvaDeusOrquidea": SIMD3<Float>(1.3, 1.3, 1.3)
    ]

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView(frame: .zero)
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true

        // tenta carregar .scn, se falhar tenta .dae/.usdz (opcional)
        if let scene = SCNScene(named: "\(named).scn") {
            applyScene(scene, to: scnView)
        } else if let scene = SCNScene(named: "\(named).dae") {
            applyScene(scene, to: scnView)
        } else if let scene = SCNScene(named: "\(named).usdz") {
            applyScene(scene, to: scnView)
        } else {
            // fallback: tenta carregar diretamente como SCNScene(named:)
            print("CustomSceneView: não encontrou cena para '\(named)' (.scn/.dae/.usdz).")
        }

        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // nada dinâmico por enquanto; se quiser trocar o modelo em runtime,
        // remova a cena antiga e chame applyScene novamente
    }

    // MARK: - Helpers
    private func applyScene(_ scene: SCNScene, to scnView: SCNView) {
        scene.background.contents = UIColor.clear

        // aplica escala ao nó root (ou a um nó específico se precisar)
        let scale = insetoEscalas[named] ?? SIMD3<Float>(0.05, 0.05, 0.05)
        scene.rootNode.scale = SCNVector3(scale.x, scale.y, scale.z)

        scnView.scene = scene
    }
}

// MARK: - Raridade helpers (funções que escolhem ícone e cor)

fileprivate func iconName(for rawRarity: String) -> String {
    let folded = rawRarity.trimmingCharacters(in: .whitespacesAndNewlines)
        .folding(options: .diacriticInsensitive, locale: .current)
        .lowercased()
    switch folded {
    case "raro", "rare": return "sparkles"
    case "epico", "épico", "epic": return "star.fill"
    case "lendario", "lendário", "legendary": return "crown.fill"
    case "secret", "secreto", "secrets": return "eye.fill"
    default: return "leaf.fill" // comum
    }
}

fileprivate func colorForRarity(_ rawRarity: String) -> Color {
    let folded = rawRarity.trimmingCharacters(in: .whitespacesAndNewlines)
        .folding(options: .diacriticInsensitive, locale: .current)
        .lowercased()
    switch folded {
    case "raro", "rare": return Color.blue
    case "epico", "épico", "epic": return Color.orange
    case "lendario", "lendário", "legendary": return Color.yellow
    case "secret", "secreto", "secrets": return Color.purple
    default: return Color.green
    }
}

fileprivate func rarityBackgroundGradient(for rawRarity: String) -> LinearGradient {
    let folded = rawRarity.trimmingCharacters(in: .whitespacesAndNewlines)
        .folding(options: .diacriticInsensitive, locale: .current)
        .lowercased()
    switch folded {
    case "raro", "rare":
        return LinearGradient(colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
    case "epico", "épico", "epic":
        return LinearGradient(colors: [Color.orange.opacity(0.95), Color.pink.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
    case "lendario", "lendário", "legendary":
        return LinearGradient(colors: [Color.yellow.opacity(0.95), Color.orange.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
    case "secret", "secreto", "secrets":
        return LinearGradient(colors: [Color.black.opacity(0.85), Color.purple.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)
    default:
        return LinearGradient(colors: [Color.green.opacity(0.9), Color.teal.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// MARK: - Preview
struct InsetoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let artropodes = carregarArtropodes()
        if artropodes.indices.contains(11) {
            InsetoDetailView(artropode: artropodes[11])
        } else {
            Text("Nenhum inseto disponível")
        }
    }
}
