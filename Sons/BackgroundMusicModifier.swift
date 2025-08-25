import SwiftUI

struct BackgroundMusicModifier: ViewModifier {
    let track: AudioManager.Track
    let fadeDuration: TimeInterval

    init(track: AudioManager.Track, fadeDuration: TimeInterval = 0.8) {
        self.track = track
        self.fadeDuration = fadeDuration
    }

    func body(content: Content) -> some View {
        content
            .onAppear {
                AudioManager.shared.play(track, fadeDuration: fadeDuration)
            }
            // não damos stop no onDisappear → deixa tocar
    }
}

extension View {
    func backgroundMusic(_ track: AudioManager.Track, fadeDuration: TimeInterval = 0.8) -> some View {
        self.modifier(BackgroundMusicModifier(track: track, fadeDuration: fadeDuration))
    }
}
