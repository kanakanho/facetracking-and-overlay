//
//  Sentences.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/29.
//

import SwiftUI

@MainActor
/// 会話全体を格納して書き出す
class ExternalSentences: ExternalFileStorage<ExternalPassage> {
    @Published private(set) var isVoiceRecognition: Bool = false
    
    func toggleVoiceRecognition() {
        if isVoiceRecognition {
            // 音声認識の終了処理
        } else {
            // 音声認識の開始処理
        }
        isVoiceRecognition.toggle()
    }
}

/// 認識された文章を格納する構造体
struct ExternalPassage: Encodable {
    let time: Date
    let passage: [String]
}
