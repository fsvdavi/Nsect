import SwiftUI
import Shimmer
import SDWebImageSwiftUI
import UIKit

struct InsetoView: View {
    var artropode: Artropode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // IMAGEM DESTACADA
                WebImage(url: URL(string: artropode.imagemURL))
                    .resizable()
                    .onSuccess { image, data, cacheType in
                        // Lógica de sucesso (opcional): aqui você pode fazer algo com a imagem carregada
                        print("Imagem carregada com sucesso!")
                    }
                    .onFailure { error in
                        // Lógica de falha (opcional): aqui você pode lidar com erros de carregamento
                        print("Erro ao carregar imagem: \(error.localizedDescription)")
                    }
                    .placeholder { // <-- Abertura da closure para o placeholder
                        Image(systemName: "leaf") // Sua imagem de placeholder
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100) // Exemplo de tamanho para o placeholder
                            .foregroundColor(.gray)
                    } // <-- Fechamento da closure para o placeholder
                    .indicator(.activity) // <-- Modificador indicator (direto)
                    .transition(.fade(duration: 0.5)) // <-- Modificador transition (direto)
                    .scaledToFill()
                    .frame(height: 260)
                    .clipped()
                    .cornerRadius(25)
                    .shadow(color: .green.opacity(0.4), radius: 12, x: 0, y: 5)

                // NOME POPULAR
                Text(artropode.nomePopular.capitalized)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(.green)
                    .shimmering()

                // NOME CIENTÍFICO
                Text(artropode.nomeCientifico)
                    .italic()
                    .font(.system(size: 18, weight: .medium, design: .serif))
                    .foregroundColor(.gray)

                Divider()

                GroupBox(label: Label("Informações", systemImage: "info.circle.fill")) {
                    InfoRow(title: "Classe", value: artropode.classe, icon: "leaf")
                    InfoRow(title: "Habitat", value: artropode.habitat, icon: "globe.americas")
                    InfoRow(title: "Tamanho / Peso", value: "\(artropode.tamanho) / \(artropode.peso)", icon: "scalemass")
                }
                .groupBoxStyle(.automatic)

                GroupBox(label: Label("Descrição", systemImage: "text.book.closed")) {
                    Text(artropode.descricao)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                }

                GroupBox(label: Label("Curiosidade", systemImage: "lightbulb.fill")) {
                    Text(artropode.curiosidade)
                        .font(.body)
                        .foregroundColor(.green)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 4)
                }
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [.green.opacity(0.1), .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
        )
    }
}

struct InfoRow: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(title + ":")
                .bold()
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    let inseto = Artropode(
        classe: "Insecta",
        nomeCientifico: "Odontomachus bauri",
        nomePopular: "Formiga-de-mandíbula-armadilha",
        habitat: "Solo de florestas tropicais",
        descricao: "Formiga que usa suas mandíbulas como catapultas para atacar ou fugir.",
        curiosidade: "Pode atingir uma velocidade de 230 km/h com as mandíbulas.",
        tamanho: "1.3 cm",
        peso: "0.004 g",
        imagemURL: "https://static.inaturalist.org/photos/52135431/large.jpeg"
     )
    return InsetoView(artropode: inseto)
}
