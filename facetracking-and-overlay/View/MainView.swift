//
//  PadView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>
    var virtualContentType: VirtualContentType
    @ObservedObject var externalSentences: ExternalSentences
    
    var body: some View {
        GeometryReader{ geo in
            if geo.size.width > geo.size.height * 2 {
                HStack {
                    FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                        .edgesIgnoringSafeArea(.all)
                        .onDisappear {
                            externalBlendShapes.endRecording()
                        }
                        .id(virtualContentType)
                        .frame(width: (geo.size.height - 32) / 3 * 4, height: geo.size.height - 32)
                        .cornerRadius(12)
                        .padding(.vertical, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            } else if geo.size.width > geo.size.height {
                HStack {
                    FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                        .edgesIgnoringSafeArea(.all)
                        .onDisappear {
                            externalBlendShapes.endRecording()
                        }
                        .id(virtualContentType)
                        .frame(width: geo.size.height / 6 * 4, height: geo.size.height / 2)
                        .cornerRadius(12)
                        .padding(.leading, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            } else {
                VStack {
                    FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                        .edgesIgnoringSafeArea(.all)
                        .onDisappear {
                            externalBlendShapes.endRecording()
                        }
                        .id(virtualContentType)
                        .frame(width: geo.size.width - 32, height: (geo.size.width - 32) * 3 / 4)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            }
        }
    }
}
