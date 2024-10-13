//
// Project Name: Memorize
// File Name:    EmojiMemoryGame.swift
// Author:       Shuyi Liu
// Update Date:  2024-10-13
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🌭", "🥞", "🍮", "🍧", "🥠", "🍥", "🍩", "🍬", "🥯", "🍭", "🍨", "🥮"]

    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: 10) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                emojis[pairIndex]
            } else {
                "⁉️"
            }
        }
    }

    @Published private var model = createMemoryGame()

    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }

    func shuffle() {
        model.shuffle()
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
