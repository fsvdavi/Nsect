import SwiftUI

struct MoldInsectView: View {
    var id: Int
    var nome: String
    var cor: Color

    var body: some View {
        VStack(spacing: 16) {
            // Ícone do inseto circular no topo
            Image("antimage")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 150)
                .offset(y: 100)
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


                    .frame(width: 180, height: 120)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .frame(width: 160, height: 35)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                    .overlay {
                        HStack(spacing: 20) {
                            Text("#\(String(format: "%02d", id))")
                                .font(.system(size: 14, weight: .bold))
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.leading, 12)

                            Text(nome)
                                .font(.headline)
                                .foregroundColor(.white)

                            Spacer()
                        }
                    }
                    .offset(y: -10) // sobe o retângulo cinza para sobrepor parte do verde
            }
            .frame(height: 120 + 25) // ajustar altura do ZStack para o offset funcionar
        }
        .frame(width: 180, height: 200)
    }
}

#Preview {
    MoldInsectView(id: 1, nome: "Besouro", cor: .green)
}
