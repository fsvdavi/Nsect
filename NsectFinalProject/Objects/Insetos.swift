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

/// Função auxiliar para separar campos CSV considerando aspas
func parseCSVLine(_ line: String) -> [String] {
    var results: [String] = []
    var current = ""
    var insideQuotes = false
    let characters = Array(line)

    var i = 0
    while i < characters.count {
        let char = characters[i]

        if char == "\"" {
            if insideQuotes && i + 1 < characters.count && characters[i + 1] == "\"" {
                // Aspas escapadas dentro de um campo
                current.append("\"")
                i += 1
            } else {
                // Abre ou fecha aspas
                insideQuotes.toggle()
            }
        } else if char == "," && !insideQuotes {
            // Separador de campo
            let trimmed = current.trimmingCharacters(in: .whitespaces)
            results.append(trimmed.trimmingCharacters(in: CharacterSet(charactersIn: "\"")))
            current = ""
        } else {
            // Caractere normal
            current.append(char)
        }
        i += 1
    }
    // Último campo
    let trimmed = current.trimmingCharacters(in: .whitespaces)
    results.append(trimmed.trimmingCharacters(in: CharacterSet(charactersIn: "\"")))

    return results
}

func carregarArtropodes() -> [Artropode] {
    var lista: [Artropode] = []

    guard let caminho = Bundle.main.path(forResource: "Catálogo", ofType: "csv") else {
        print("❌ Arquivo não encontrado.")
        return []
    }

    do {
        let conteudo = try String(contentsOfFile: caminho, encoding: .utf8)
        let linhas = conteudo.components(separatedBy: "\n")

        for (index, linha) in linhas.enumerated() {
            if index == 0 { continue } // Pula cabeçalho
            guard !linha.isEmpty else { continue }

            let col = parseCSVLine(linha)
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
