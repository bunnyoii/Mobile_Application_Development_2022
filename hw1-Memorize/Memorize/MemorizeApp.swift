//
// Project Name: Memorize
// File Name:    MemorizeApp.swift
// Author:       Shuyi Liu
// Update Date:  2024-10-13
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()

    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
