import SwiftUI

struct InventoryInsectView: View {
    @ObservedObject var arCoordinator: ARCoordinator
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .alfabetica

    enum SortOption: String, CaseIterable, Identifiable {
        case porID = "Por ID"
        case alfabetica = "Alfabética"

        var id: String { self.rawValue }
    }

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

    // controle do painel de ordenação
    @State private var showingSortOptions: Bool = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Image("background")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    // top bar (título)
                    ZStack {
                        Color(red: 0, green: 0.3, blue: 0)
                            .mask(
                                RoundedRectangle(cornerRadius: 50, style: .continuous)
                                    .padding(.top, -20)
                            )
                        Image("nsectTitle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 90)
                            .padding(.horizontal, 16)
                            .padding(.top, 40)
                    }
                    .frame(height: 160)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)

                    // SEARCH BAR + FILTER BUTTON ROW
                    HStack(spacing: 12) {
                        SearchBarInsects(searchText: $searchText)

                        // botão que expande painel de ordenação
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                showingSortOptions.toggle()
                            }
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(14)
                                .background(
                                    Circle()
                                        .fill(LinearGradient(colors: [.green, .mint],
                                                             startPoint: .topLeading,
                                                             endPoint: .bottomTrailing))
                                )
                                .shadow(color: .green.opacity(0.45), radius: 6, x: 0, y: 3)
                        }
                        .accessibilityLabel("Mostrar opções de ordenação")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // PAINEL EXPANSÍVEL DE OPÇÕES (aparece abaixo da search bar)
                    if showingSortOptions {
                        HStack(spacing: 12) {
                            ForEach(SortOption.allCases) { option in
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        sortOption = option
                                        showingSortOptions = false // fecha após escolher
                                    }
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: option == .porID ? "number" : "textformat")
                                            .font(.system(size: 14, weight: .semibold))
                                        Text(option.rawValue)
                                            .font(.system(size: 14, weight: .semibold))
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(sortOption == option ? Color.green.opacity(0.95) : Color.white.opacity(0.92))
                                    .foregroundColor(sortOption == option ? .white : .black)
                                    .clipShape(Capsule())
                                    .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 18)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // GRID - resultados filtrados e ordenados
                    ScrollView {
                        let items = filteredAndSortedInsects
                        if items.isEmpty {
                            VStack(spacing: 10) {
                                Image(systemName: "ant.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.9))
                                Text("Nenhum inseto encontrado")
                                    .foregroundColor(.white.opacity(0.95))
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 40)
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(items, id: \.id) { inseto in
                                    NavigationLink(destination: InsetoDetailView(artropode: inseto)
                                        .backgroundMusic(.inventoryDetail) // 🔊 detalhe também usa mesma trilha
                                    ) {
                                        MoldInsectView(insect: inseto)
                                            .shadow(color: .black.opacity(0.22), radius: 4, x: 0, y: 2)
                                            .scaleEffect(0.995)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 6)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.top)
            }
            .ignoresSafeArea(edges: .top)
        }
        .backgroundMusic(.inventoryDetail) // 🔊 música do inventário
    }

    // Search bar component (reaproveitado)
    struct SearchBarInsects: View {
        @Binding var searchText: String

        var body: some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.green.opacity(0.85))
                    .font(.system(size: 20, weight: .bold))

                TextField("Buscar inseto...", text: $searchText)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .foregroundColor(.black)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
            .background(
                LinearGradient(colors: [.white.opacity(0.95), .green.opacity(0.14)],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
            )
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 1)
        }
    }

    // MARK: - Filtragem e ordenação
    private var filteredAndSortedInsects: [Artropode] {
        // filtra por nome popular, nome científico e habitat
        let lower = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var results = arCoordinator.insetosCapturados.filter { art in
            lower.isEmpty ||
            art.nomePopular.lowercased().contains(lower) ||
            art.nomeCientifico.lowercased().contains(lower) ||
            art.habitat.lowercased().contains(lower)
        }

        // ordenação exigida: por ID (numérico quando possível) ou alfabética
        switch sortOption {
        case .porID:
            results.sort { a, b in
                if let ai = Int(a.id), let bi = Int(b.id) {
                    return ai < bi
                } else {
                    return a.id < b.id
                }
            }
        case .alfabetica:
            results.sort { $0.nomePopular.localizedCaseInsensitiveCompare($1.nomePopular) == .orderedAscending }
        }

        return results
    }
}


// Preview seguro: wrapper que popula o coordinator em onAppear
#Preview {
    struct InventoryPreviewWrapper: View {
        @StateObject private var arCoordinator = ARCoordinator()

        // dados de exemplo
        private let exemploInsetos: [Artropode] = [
            Artropode(classe: "Insecta", nomeCientifico: "Camponotus spp.", nomePopular: "Formiga Preta", habitat: "Ambientes urbanos e florestais", descricao: "Formiga comum no Brasil, constrói ninhos em madeira ou solo.", curiosidade: "Se comunicam por feromônios químicos complexos, funcionando como uma 'internet química'.", tamanho: "0.5 cm", peso: "0.005 g", imagemURL: "https://upload.wikimedia.org/wikipedia/commons/f/f4/Camponotus_pennsylvanicus_ant.jpg", modelo3d: "ant", id: "01"),
            Artropode(classe: "Insecta", nomeCientifico: "Coccinella septempunctata", nomePopular: "Joaninha", habitat: "Jardins e plantações", descricao: "Inseto colorido e convidativo, predador de pragas como pulgões.", curiosidade: "Quando ameaçada libera um fluido amarelo com cheiro forte para afastar predadores.", tamanho: "0.6 cm", peso: "0.006 g", imagemURL: "https://upload.wikimedia.org/wikipedia/commons/1/15/Coccinella_septempunctata_01.JPG", modelo3d: "Ladybug", id: "02"),
            Artropode(classe: "Arachnida", nomeCientifico: "Phoneutria fera", nomePopular: "Aranha Armadeira", habitat: "Matas e áreas próximas ao solo", descricao: "Aranha de comportamento ativo e veneno potente.", curiosidade: "Seu veneno é poderoso, mas picadas humanas são tratadas com antídoto e cuidados médicos.", tamanho: "6 cm", peso: "2 g", imagemURL: "https://upload.wikimedia.org/wikipedia/commons/8/8d/Phoneutria_nigriventer_%28aka%29.jpg", modelo3d: "spider", id: "03"),
            Artropode(classe: "Insecta", nomeCientifico: "Tenodera aridifolia", nomePopular: "Louva-a-Deus", habitat: "Vegetação baixa e arbustos", descricao: "Predador paciente que usa suas patas dianteiras para agarrar presas.", curiosidade: "Algumas espécies apresentam camuflagem avançada.", tamanho: "7 cm", peso: "3 g", imagemURL: "https://upload.wikimedia.org/wikipedia/commons/9/99/Mantis2.jpg", modelo3d: "mantis", id: "04"),
            Artropode(classe: "Arachnida", nomeCientifico: "Tityus serrulatus", nomePopular: "Escorpião Amarelo", habitat: "Áreas urbanas e entulhos", descricao: "Escorpião comum em áreas urbanas do Brasil.", curiosidade: "Pode sobreviver longos períodos sem alimento.", tamanho: "6 cm", peso: "5 g", imagemURL: "https://www.estado.rs.gov.br/upload/recortes/202501/29180411_2167371_GDO.jpeg", modelo3d: "Scorpion", id: "05"),
            Artropode(classe: "Insecta", nomeCientifico: "Dynastes hercules", nomePopular: "Besouro-Hércules", habitat: "Florestas tropicais", descricao: "Um dos maiores besouros do mundo.", curiosidade: "Pode erguer objetos muito maiores que ele.", tamanho: "17 cm", peso: "100 g", imagemURL: "https://upload.wikimedia.org/wikipedia/commons/6/66/Dynastes_hercules_male_-_P%C3%A9rou.jpg", modelo3d: "besouro", id: "06")
        ]

        var body: some View {
            InventoryInsectView(arCoordinator: arCoordinator)
                .onAppear {
                    // popula somente se estiver vazio (evita sobrescrever durante hot-reload)
                    if arCoordinator.insetosCapturados.isEmpty {
                        arCoordinator.insetosCapturados = exemploInsetos
                    }
                }
        }
    }

    return InventoryPreviewWrapper()
}
