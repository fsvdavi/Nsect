import SwiftUI
import RealityKit

struct MoldInsectView: View {
    var id: Int
    var nome: String
    var cor: Color
    let artropode: Artropode

    var body: some View {
        VStack(spacing: 16) {
            // Ícone do inseto circular no topo
            Model3D(named: "\(artropode.modelo3d).usdz") { model in
                           model
                               .resizable()
                               .aspectRatio(contentMode: .fit)
                               .frame(height: 200)
                               .shadow(radius: 6)
                       } placeholder: {
                           ProgressView()
                               .frame(height: 200)
                       }

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
                    .offset(y: -10)             }
            .frame(height: 120 + 25)
        }
    }


#Preview {
    MoldInsectView(id: 1, nome: "Besouro", cor: .green)
}
