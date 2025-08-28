//
//  SoundEffectsManager.swift
//  NsectFinalProject
//
//  Created by found on 28/08/25.
//

import Foundation
import AVFoundation

final class SoundEffectsManager {
    static let shared = SoundEffectsManager()
    
    private var sfxPlayers: [AVAudioPlayer] = []
    
    private init() {}
    
    func play(_ name: String, ext: String = "mp3", volume: Float = 1.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("SoundEffectsManager: som não encontrado ->", name)
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            // guarda a referência até terminar
            sfxPlayers.append(player)
            
            // remove quando acabar
            DispatchQueue.main.asyncAfter(deadline: .now() + player.duration) { [weak self, weak player] in
                if let player = player {
                    self?.sfxPlayers.removeAll { $0 == player }
                }
            }
        } catch {
            print("SoundEffectsManager: erro ao reproduzzir efeito sonoro ->", error)
        }
    }
}
