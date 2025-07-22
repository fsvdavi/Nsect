import SwiftUI

struct InventoryInsectView: View {
    var artropodes: [Artropode]

    // Two columns grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(artropodes, id: \.id) { insect in
                    MoldInsectView(insect: insect)
                }
            }
            .padding(.horizontal, 8)
        }
    }
}
#Preview {
    let insetos: [Artropode] = [
        Artropode(
            classe: "Insecta",
            nomeCientifico: "Formica fusca",
            nomePopular: "Formiga Negra",
            habitat: "Solo e folhas",
            descricao: "Uma formiga comum encontrada em diversos habitats.",
            curiosidade: "É capaz de levantar várias vezes seu próprio peso.",
            tamanho: "0.5 cm",
            peso: "0.003 g",
            imagemURL: "",
            modelo3d: "ant",
            id: "01"
        ),
        Artropode(
            classe: "Insecta",
            nomeCientifico: "Coccinella septempunctata",
            nomePopular: "Joaninha",
            habitat: "Jardins e plantações",
            descricao: "Inseto colorido com capacidade de voo.",
            curiosidade: "Seus pontos pretos servem como defesa visual.",
            tamanho: "0.7 cm",
            peso: "0.005 g",
            imagemURL: "",
            modelo3d: "mantis",
            id: "02"
        )
    ]

    return InventoryInsectView(artropodes: insetos)
}
