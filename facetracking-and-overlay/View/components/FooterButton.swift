//
//  FooterButton.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct FooterButton: View {
    @ObservedObject var externalSentences: ExternalSentences
    
    var body: some View {
        ZStack{
            if externalSentences.isRecording {
                HStack{
                    IsVoiceRecognitionButtonView(externalSentences: externalSentences)
                }
            }
            HStack {
                if externalSentences.isRecording {
                    Spacer()
                }
                IsRecordingButtonView(externalSentences: externalSentences)
            }
        }
    }
}
