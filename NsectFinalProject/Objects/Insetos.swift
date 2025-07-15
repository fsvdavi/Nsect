import SwiftData
import Foundation

@Model
class Artrópode {
    var classe: String
    var nomeCientifico: String
    var nomePopular: String
    var habitat: String
    var descricao: String
    var curiosidade: String
    var tamanho: String
    var peso: String
    var imagemURL: String

    init(classe: String, nomeCientifico: String, nomePopular: String, habitat: String, descricao: String, curiosidade: String, tamanho: String, peso: String, imagemURL: String) {
        self.classe = classe
        self.nomeCientifico = nomeCientifico
        self.nomePopular = nomePopular
        self.habitat = habitat
        self.descricao = descricao
        self.curiosidade = curiosidade
        self.tamanho = tamanho
        self.peso = peso
        self.imagemURL = imagemURL
    }
}

func carregarArtrópodes() -> [Artrópode] {
    var lista: [Artrópode] = []

    guard let caminho = Bundle.main.path(forResource: "Catálogo - catálogo_completo", ofType: "csv") else {
        print("❌ Arquivo não encontrado.")
        return []
    }

    do {
        let conteudo = try String(contentsOfFile: caminho, encoding: .utf8)
        let linhas = conteudo.components(separatedBy: "\n")
        
        for (index, linha) in linhas.enumerated() {
            if index == 0 { continue } // Pula o cabeçalho
            let colunas = linha.components(separatedBy: ",")

            if colunas.count >= 9 {
                let artrópode = Artrópode(
                    classe: colunas[0],
                    nomeCientifico: colunas[1],
                    nomePopular: colunas[2],
                    habitat: colunas[3],
                    descricao: colunas[4],
                    curiosidade: colunas[5],
                    tamanho: colunas[6],
                    peso: colunas[7],
                    imagemURL: colunas[8]
                )
                lista.append(artrópode)
            }
        }
    } catch {
        print("❌ Erro ao ler o arquivo: \(error)")
    }

    return lista
}
