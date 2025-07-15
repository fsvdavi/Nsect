import SwiftUI

struct InsetoView: View {
    var artropode: Artropode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // IMAGEM DESTACADA
            AsyncImage(url: URL(string: artropode.imagemURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 220)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(20)
                    .shadow(radius: 6)
            } placeholder: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 220)
                    .overlay(
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    )
            }

            // NOME POPULAR (TÍTULO)
            Text(artropode.nomePopular.capitalized)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            // NOME CIENTÍFICO
            Text(artropode.nomeCientifico)
                .italic()
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundColor(.secondary)

            Divider().padding(.vertical, 4)

            // INFORMAÇÕES GERAIS
            Group {
                HStack {
                    Label("Classe", systemImage: "leaf.fill")
                    Spacer()
                    Text(artropode.classe)
                        .foregroundColor(.blue)
                }

                HStack {
                    Label("Habitat", systemImage: "globe.americas.fill")
                    Spacer()
                    Text(artropode.habitat)
                        .foregroundColor(.green)
                }

                HStack {
                    Label("Tamanho / Peso", systemImage: "ruler.fill")
                    Spacer()
                    Text("\(artropode.tamanho) • \(artropode.peso)")
                }
            }
            .font(.subheadline)

            Divider().padding(.vertical, 4)

            // DESCRIÇÃO E CURIOSIDADE
            VStack(alignment: .leading, spacing: 6) {
                Text("📘 Descrição")
                    .font(.headline)
                Text(artropode.descricao)
                    .font(.body)
                    .foregroundColor(.primary)

                Text("🧠 Curiosidade")
                    .font(.headline)
                    .padding(.top, 4)
                Text(artropode.curiosidade)
                    .font(.body)
                    .foregroundColor(.primary)
            }

        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .shadow(radius: 6)
        )
        .padding()
    }
}

#Preview {
    let insetoTeste = Artropode(
        classe: "Insecta",
        nomeCientifico: "Odontomachus bauri",
        nomePopular: "Formiga-de-mandíbula-trap",
        habitat: "Solo de florestas tropicais",
        descricao: "Formiga que pode arremessar a si mesma com suas mandíbulas.",
        curiosidade: "Ela consegue bater as mandíbulas com tanta força que se lança para trás para fugir de predadores.",
        tamanho: "1.3 cm",
        peso: "0.004 g",
        imagemURL: "https://upload.wikimedia.org/wikipedia/commons/3/33/Odontomachus_bauri.png"
    )
    
    return InsetoView(artropode: insetoTeste)
}

