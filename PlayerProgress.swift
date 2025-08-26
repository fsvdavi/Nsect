// PlayerProgress.swift
// Gerencia XP, nível e desbloqueio de raridades

import Foundation
import Combine

@MainActor
final class PlayerProgress: ObservableObject, Codable {
    // MARK: - Tipos
    enum Rarity: String, Codable, CaseIterable {
        case comum = "Comum"
        case raro = "Raro"
        case epico = "Épico"
        case lendario = "Lendário"
        case secret = "Secret"
    }

    // MARK: - Published (estado que as views observam)
    @Published var level: Int
    @Published var xp: Int

    // MARK: - Configurações
    static let maxLevel = 10

    /// mapa de XP concedido por raridade (padrões, ajuste se quiser)
    let xpPerRarity: [Rarity: Int] = [
        .comum: 12,
        .raro: 35,
        .epico: 90,
        .lendario: 220,
        .secret: 800
    ]

    // MARK: - Inicializadores / Codable
    init(level: Int = 1, xp: Int = 0) {
        self.level = max(1, level)
        self.xp = max(0, xp)
        clampLevelAndXP()
    }

    enum CodingKeys: String, CodingKey {
        case level
        case xp
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(level, forKey: .level)
        try container.encode(xp, forKey: .xp)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        level = try container.decode(Int.self, forKey: .level)
        xp = try container.decode(Int.self, forKey: .xp)
        clampLevelAndXP()
    }

    // MARK: - XP / Level logic

    func xpRequired(forLevel level: Int) -> Int {
        guard level >= 1 else { return 100 }
        return level * level * 100
    }

    var xpToNextLevel: Int {
        if level >= Self.maxLevel { return 0 }
        return max(0, xpRequired(forLevel: level) - xp)
    }

    /// Adiciona XP e faz a lógica de subida de nível automaticamente.
    /// Retorna true se subiu de nível pelo menos 1 vez.
    @discardableResult
    func addXP(_ amount: Int) -> Bool {
        guard amount > 0 else { return false }
        var leveled = false
        xp += amount

        while level < Self.maxLevel && xp >= xpRequired(forLevel: level) {
            xp -= xpRequired(forLevel: level)
            level += 1
            leveled = true
            if level >= Self.maxLevel {
                xp = 0
                break
            }
        }

        save()
        // reavaliar unlocks localmente (sincrono)
        evaluateUnlocks()
        return leveled
    }

    /// Concede XP baseado na raridade (usa xpPerRarity)
    func grantXPForCapture(rarity: Rarity) {
        if let amount = xpPerRarity[rarity] {
            _ = addXP(amount)
        } else {
            _ = addXP(10)
        }
    }

    /// Força reavaliação dos unlocks (útil quando outra classe anexa ou carregamos do disco)
    func evaluateUnlocks() {
        // atualiza/persiste estado; as views observam level/xp
        save()
    }

    // MARK: - Adaptadores para uso externo (aceitam String e são `async` para chamadas de fora do MainActor)

    /// Converte string de raridade para enum (tolerante a acentuação e variações)
    func rarityFromString(_ raw: String) -> Rarity {
        let folded = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: .diacriticInsensitive, locale: .current)
            .lowercased()

        switch folded {
        case "comum", "common":
            return .comum
        case "raro", "rare":
            return .raro
        case "epico", "épico", "epic":
            return .epico
        case "lendario", "lendário", "legendary":
            return .lendario
        case "secret", "secreto", "secrets":
            return .secret
        default:
            return .comum
        }
    }

    /// Async wrapper para checar se a raridade está desbloqueada — chame: `await playerProgress.canSpawn(rarity: art.raridade)`
    func canSpawn(rarity raw: String) async -> Bool {
        let r = rarityFromString(raw)
        return canSpawn(rarity: r)
    }

    /// Async wrapper para conceder XP a partir de uma string de raridade
    func grantXPForCapture(raw: String) async {
        let r = rarityFromString(raw)
        grantXPForCapture(rarity: r)
    }

    /// Async wrapper para forçar reavaliação (externa)
    func evaluateUnlocksAsync() async {
        evaluateUnlocks()
    }

    // MARK: - Raridades desbloqueadas (sua regra)
    var unlockedRarities: [Rarity] {
        var set: [Rarity] = []
        set.append(.comum)
        set.append(.raro)
        if level >= 6 { set.append(.epico) }
        if level >= 8 { set.append(.lendario) }
        if level >= 10 { set.append(.secret) }
        return set
    }

    /// Versão interna por enum (sincrona)
    func canSpawn(rarity: Rarity) -> Bool {
        return unlockedRarities.contains(rarity)
    }

    // MARK: - Reset / Helpers
    func resetProgress() {
        level = 1
        xp = 0
        save()
    }

    private func clampLevelAndXP() {
        if level < 1 { level = 1 }
        if level > Self.maxLevel { level = Self.maxLevel }
        if level >= Self.maxLevel { xp = 0 }
        else {
            let needed = xpRequired(forLevel: level)
            if xp < 0 { xp = 0 }
            if xp >= needed { xp = xp % needed }
        }
    }

    // MARK: - Persistência (JSON em Documents)
    private static var filename = "playerProgress.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent(Self.filename)
    }

    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            try data.write(to: fileURL, options: [.atomicWrite])
        } catch {
            print("Erro salvando PlayerProgress:", error)
        }
    }

    static func load() -> PlayerProgress? {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = dir.appendingPathComponent(Self.filename)
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let obj = try decoder.decode(PlayerProgress.self, from: data)
            return obj
        } catch {
            return nil
        }
    }

    static func loadOrCreate() -> PlayerProgress {
        if let loaded = load() { return loaded }
        else {
            let p = PlayerProgress()
            p.save()
            return p
        }
    }
}
