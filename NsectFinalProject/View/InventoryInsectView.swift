import SwiftUI

struct InventoryInsectView: View {
    var artropodes: [Artropode]

    // Grid layout
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let topBarHeight: CGFloat = 160

    var body: some View {
        NavigationStack {
            
            ZStack(alignment: .top) {
                // Background color or image
                Color(white: 0.95).ignoresSafeArea()

                // Top Title Bar
                ZStack {
                    Rectangle()
                        .fill(Color(red: 0, green: 0.3, blue: 0))
                        .frame(height: topBarHeight)
                        .clipShape(RoundedCorners(radius: 20, corners: [.bottomLeft, .bottomRight]))

                    Image("nsectTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.top, 40)
                }
                .ignoresSafeArea(edges: .top)

                // Grid of insects
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(artropodes, id: \.id) { insect in
                            MoldInsectView(insect: insect)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, topBarHeight + 10)
                }
            }
        }
    }
}

#Preview {
    let sample = [
        Artropode(classe: "Insecta", nomeCientifico: "Formica fusca", nomePopular: "Formiga Negra", habitat: "Solo e folhas", descricao: "Uma formiga comum.", curiosidade: "Levanta várias vezes seu peso.", tamanho: "0.5 cm", peso: "0.003 g", imagemURL: "", modelo3d: "RedAnt", id: "01"),
        Artropode(classe: "Insecta", nomeCientifico: "Coccinella septempunctata", nomePopular: "Joaninha", habitat: "Jardins", descricao: "Inseto colorido.", curiosidade: "Pontos servem de defesa.", tamanho: "0.7 cm", peso: "0.005 g", imagemURL: "", modelo3d: "mantis", id: "02")
    ]
    InventoryInsectView(artropodes: sample)
}
