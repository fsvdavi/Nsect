import SwiftData
import Foundation

@Model
class Artropode {
    var classe: String
    var nomeCientifico: String
    var nomePopular: String
    var habitat: String
    var descricao: String
    var curiosidade: String
    var tamanho: String
    var peso: String
    var imagemURL: String
    var modelo3d: String
    var id: String

    init(
        classe: String,
        nomeCientifico: String,
        nomePopular: String,
        habitat: String,
        descricao: String,
        curiosidade: String,
        tamanho: String,
        peso: String,
        imagemURL: String,
        modelo3d: String,
        id: String
    ) {
        self.classe = classe
        self.nomeCientifico = nomeCientifico
        self.nomePopular = nomePopular
        self.habitat = habitat
        self.descricao = descricao
        self.curiosidade = curiosidade
        self.tamanho = tamanho
        self.peso = peso
        self.imagemURL = imagemURL
        self.modelo3d = modelo3d
        self.id = id
    }
}

func carregarArtrópodes() -> [Artropode] {
    var lista: [Artropode] = []

    guard let caminho = Bundle.main.path(forResource: "Catálogo", ofType: "csv") else {
        print("❌ Arquivo não encontrado.")
        return []
    }

    do {
        let conteudo = try String(contentsOfFile: caminho, encoding: .utf8)
        let linhas = conteudo.components(separatedBy: "\n")

        for (index, linha) in linhas.enumerated() {
            if index == 0 { continue }
            let col = linha.components(separatedBy: ",")
            guard col.count >= 11 else { continue }

            let art = Artropode(
                classe: col[0],
                nomeCientifico: col[1],
                nomePopular: col[2],
                habitat: col[3],
                descricao: col[4],
                curiosidade: col[5],
                tamanho: col[6],
                peso: col[7],
                imagemURL: col[8],
                modelo3d: col[9],
                id: col[10]
            )
            lista.append(art)
        }
    } catch {
        print("❌ Erro ao ler o arquivo:", error)
    }

    return lista
}
