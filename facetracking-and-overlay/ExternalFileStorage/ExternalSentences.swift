//
//  Sentences.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/29.
//

import SwiftUI

/// 会話全体を格納して書き出す
class ExternalSentences: ExternalFileStorage<ExternalPassage> {
    @Published private(set) var isVoiceRecognition: Bool = false
    
    func toggleVoiceRecognition() {
        isVoiceRecognition.toggle()
    }
}

/// 認識された文章を格納する構造体
struct ExternalPassage: Encodable {
    let time: Date
    let passage: [String]
}
