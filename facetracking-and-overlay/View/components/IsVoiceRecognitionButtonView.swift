//
//  IsVoiceRecognitionView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct IsVoiceRecognitionButtonView: View {
    @ObservedObject var externalSentences: ExternalSentences
    
    var body: some View {
        Button(action: {
            externalSentences.toggleVoiceRecognition()
        }) {
            Image(systemName: externalSentences.isVoiceRecognition ? "mic.circle.fill" : "mic.circle")
                .foregroundColor(externalSentences.isVoiceRecognition ? .red : .blue)
                .font(.title)
                .padding([.top, .bottom], 6)
        }
    }
}
