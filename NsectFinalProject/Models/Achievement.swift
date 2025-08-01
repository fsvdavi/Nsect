import Foundation

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    var isUnlocked: Bool
}
