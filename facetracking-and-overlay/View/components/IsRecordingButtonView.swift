//
//  IsRecordingButtonView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct IsRecordingButtonView: View {
    @ObservedObject var externalSentences: ExternalSentences
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            if externalSentences.isRecording {
                showAlert = true
            } else {
                externalSentences.toggleRecording()
            }
        }) {
            if externalSentences.isRecording {
                VStack {
                    Image(systemName: "stop.fill")
                        .foregroundColor(.red)
                    Text("会話終了")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.trailing, 16)
            } else {
                HStack {
                    Image(systemName: "play.fill")
                        .foregroundColor(.green)
                    Text("会話開始")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
        }
        .disabled(externalSentences.isVoiceRecognition)
        .opacity(externalSentences.isVoiceRecognition ? 0.5 : 1.0)
        .alert("本当に会話を終了しますか？", isPresented: $showAlert) {
            Button("キャンセル", role: .cancel) { }
            Button("終了", role: .destructive) {
                externalSentences.toggleRecording()
            }
        } message: {
            Text("終了すると音声認識が停止します。")
        }
    }
}
