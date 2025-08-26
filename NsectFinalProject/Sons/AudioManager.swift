import Foundation
import AVFoundation
import Combine

#if canImport(UIKit)
import UIKit
#endif

final class AudioManager: ObservableObject {
    static let shared = AudioManager()

    enum Track: Equatable {
        case homeProfile
        case inventoryDetail

        var fileName: String {
            switch self {
            case .homeProfile: return "homeProfile"
            case .inventoryDetail: return "inventoryInsect"
            }
        }

        var fileExt: String { "mp3" } // ajuste se usar outro formato
    }

    private var player: AVAudioPlayer?
    private var fadeTimer: Timer?
    private var resumeOnActive = false

    @Published private(set) var currentTrack: Track?

    private init() {
        setupAudioSession()
        addAppLifecycleObserversIfNeeded()
    }

    private func setupAudioSession() {
        #if canImport(UIKit)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.ambient, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("AudioManager: erro ao configurar AVAudioSession ->", error)
        }
        #endif
    }

    // MARK: - Play / Stop / Fade
    func play(_ track: Track, fadeDuration: TimeInterval = 1.0, volume: Float? = nil) {
        DispatchQueue.main.async {
            if self.currentTrack == track { return }

            // Definindo volume padrão por track
            let targetVolume: Float
            if let volume = volume {
                targetVolume = volume
            } else {
                switch track {
                case .homeProfile: targetVolume = 0.5
                case .inventoryDetail: targetVolume = 0.8
                }
            }

            if let existing = self.player, existing.isPlaying {
                self.crossfadeFromExisting(to: track, fadeDuration: fadeDuration, targetVolume: targetVolume)
            } else {
                self.startPlayer(for: track, targetVolume: targetVolume, fadeIn: fadeDuration)
            }
        }
    }


    func stop(fadeDuration: TimeInterval = 0.6) {
        DispatchQueue.main.async {
            self.fadeOutAndStop(duration: fadeDuration)
        }
    }

    private func startPlayer(for track: Track, targetVolume: Float, fadeIn: TimeInterval) {
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: track.fileExt) else {
            print("AudioManager: arquivo não encontrado:", track.fileName)
            return
        }

        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1
            p.volume = 0.0
            p.prepareToPlay()
            p.play()
            self.player = p
            self.currentTrack = track

            if fadeIn > 0 {
                self.fade(to: targetVolume, duration: fadeIn)
            } else {
                p.volume = targetVolume
            }
        } catch {
            print("AudioManager: erro ao criar AVAudioPlayer ->", error)
        }
    }

    private func crossfadeFromExisting(to newTrack: Track, fadeDuration: TimeInterval, targetVolume: Float) {
        fadeOutAndStop(duration: fadeDuration / 2.0) { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self?.startPlayer(for: newTrack, targetVolume: targetVolume, fadeIn: fadeDuration / 2.0)
            }
        }
    }

    private func fadeOutAndStop(duration: TimeInterval, completion: (() -> Void)? = nil) {
        guard let p = player, p.isPlaying else {
            completion?()
            return
        }
        fadeTimer?.invalidate()

        let steps = max(Int(duration / 0.05), 1)
        let initialVolume = p.volume
        var step = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] t in
            step += 1
            let fraction = Float(step) / Float(steps)
            p.volume = initialVolume * (1.0 - fraction)
            if step >= steps {
                t.invalidate()
                p.stop()
                self?.player = nil
                self?.currentTrack = nil
                completion?()
            }
        }
    }

    private func fade(to targetVolume: Float, duration: TimeInterval) {
        guard let p = player else { return }
        fadeTimer?.invalidate()
        let startVolume = p.volume
        let delta = targetVolume - startVolume
        let steps = max(Int(duration / 0.05), 1)
        var step = 0
        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            step += 1
            let fraction = Float(step) / Float(steps)
            p.volume = startVolume + delta * fraction
            if step >= steps { t.invalidate() }
        }
    }

    // MARK: - App lifecycle (pause/resume)
    private func addAppLifecycleObserversIfNeeded() {
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        #endif
    }

    @objc private func willResignActive() {
        if player?.isPlaying == true {
            player?.pause()
            resumeOnActive = true
        } else {
            resumeOnActive = false
        }
    }

    @objc private func didBecomeActive() {
        if resumeOnActive {
            player?.play()
            resumeOnActive = false
        }
    }

    // MARK: - Controls
    func setVolume(_ v: Float) {
        player?.volume = min(max(v, 0), 1)
    }

    func isPlaying() -> Bool { player?.isPlaying == true }
}
