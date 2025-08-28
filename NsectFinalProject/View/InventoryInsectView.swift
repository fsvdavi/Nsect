import SwiftUI

struct InventoryInsectView: View {
    @StateObject var arCoordinator = ARCoordinator()
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .alfabetica
    @State private var showingSortOptions: Bool = false

    enum SortOption: String, CaseIterable, Identifiable {
        case porID = "Por ID"
        case alfabetica = "Alfabética"
        var id: String { self.rawValue }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 12) {
                topBar
                searchAndFilterRow
                if showingSortOptions { sortOptionsPanel }
                ScrollView { gridView }
            }
            .edgesIgnoringSafeArea(.top)
        }
//        NavigationStack {
//
//        }
    }

    private var topBar: some View {
        ZStack {
            Color(red: 0, green: 0.3, blue: 0)
                .mask(RoundedRectangle(cornerRadius: 50, style: .continuous)
                    .padding(.top, -20))
            Image("nsectTitle")
                .resizable()
                .scaledToFit()
                .frame(height: 90)
                .padding(.horizontal, 16)
                .padding(.top, 40)
        }
        .frame(height: 160)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 2)
    }

    private var searchAndFilterRow: some View {
        HStack(spacing: 12) {
            SearchBarInsects(searchText: $searchText)
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
                            .fill(LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing))
                    )
                    .shadow(color: .green.opacity(0.45), radius: 6, x: 0, y: 3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var sortOptionsPanel: some View {
        HStack(spacing: 12) {
            ForEach(SortOption.allCases) { option in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        sortOption = option
                        showingSortOptions = false
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

    private var gridView: some View {
        let items = filteredAndSortedInsects
        
        return Group {
            if items.isEmpty {
                VStack {
                    Image(systemName: "ant.fill") // ícone nativo de formiga
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green) // deixa a formiga verde
                        .padding(.bottom, 20)
                    
                    Text("Você ainda não tem nenhum inseto")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 50)
            }
                else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(items, id: \.id) { inseto in
                        NavigationLink(destination: InsetoDetailView(artropode: inseto)
                            .navigationBarBackButtonHidden(true)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    FancyBackButton()
                                }
                            }
                            .backgroundMusic(.inventoryDetail)
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


    private var filteredAndSortedInsects: [Artropode] {
        let lower = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var results = arCoordinator.insetosCapturados.filter { art in
            lower.isEmpty ||
            art.nomePopular.lowercased().contains(lower) ||
            art.nomeCientifico.lowercased().contains(lower) ||
            art.habitat.lowercased().contains(lower)
        }

        switch sortOption {
        case .porID:
            results.sort { a, b in
                if let ai = Int(a.id), let bi = Int(b.id) {
                    return ai < bi
                } else { return a.id < b.id }
            }
        case .alfabetica:
            results.sort { $0.nomePopular.localizedCaseInsensitiveCompare($1.nomePopular) == .orderedAscending }
        }

        return results
    }

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
            .background(LinearGradient(colors: [.white.opacity(0.95), .green.opacity(0.14)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.12), radius: 3, x: 0, y: 1)
        }
    }
}


