//
//  SentencesView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct SentencesView: View {
    @ObservedObject var externalSentences: ExternalSentences
    
    @State private var isUserInteracting = false
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(externalSentences.externalData.indices, id: \.self) { index in
                    let passage = externalSentences.externalData[index]
                    HStack(alignment: .top, spacing: 8) {
                        Text(formatTime(passage.time))
                            .monospacedDigit()
                            .frame(width: 80, alignment: .leading)
                            .fixedSize()
                        
                        Text(passage.passage.joined(separator: " "))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 4)
                    .id(index)
                }
            }
            .listStyle(.inset)
            .gesture(TapGesture()
                .onEnded({ _ in
                    // タップ時は操作中フラグを解除
                    isUserInteracting = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isUserInteracting = false
                    }
                }))
            .onChange(of: externalSentences.externalData.count) {
                // 要素追加時に最下部へスクロール（ただし操作中は無視）
                guard !isUserInteracting, externalSentences.externalData.count > 0 else { return }
                withAnimation {
                    proxy.scrollTo(externalSentences.externalData.count - 1, anchor: .bottom)
                }
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
