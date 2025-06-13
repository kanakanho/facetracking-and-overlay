//
//  PadView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>
    @Binding var virtualContentType: VirtualContentType
    @ObservedObject var externalSentences: ExternalSentences
    
    var body: some View {
        GeometryReader{ geo in
            if geo.size.width > geo.size.height * 2 {
                HStack {
                    VStack {
                        Picker("Select Content Type", selection: $virtualContentType) {
                            ForEach(VirtualContentType.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                            .edgesIgnoringSafeArea(.all)
                            .id(virtualContentType)
                            .frame(width: (geo.size.height - 32) / 3 * 4, height: geo.size.height - 32)
                            .cornerRadius(12)
                    }
                    .padding(.vertical, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            } else if geo.size.width > geo.size.height {
                HStack {
                    VStack {
                        Picker("Select Content Type", selection: $virtualContentType) {
                            ForEach(VirtualContentType.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 40)
                        FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                            .edgesIgnoringSafeArea(.all)
                            .id(virtualContentType)
                            .frame(width: geo.size.height / 6 * 4, height: geo.size.height / 2)
                            .cornerRadius(12)
                    }
                    .padding(.leading, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            } else {
                VStack {
                    VStack {
                        Picker("Select Content Type", selection: $virtualContentType) {
                            ForEach(VirtualContentType.allCases) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        FaceTrackingView(virtualContentType: virtualContentType, externalBlendShapes: externalBlendShapes)
                            .edgesIgnoringSafeArea(.all)
                            .id(virtualContentType)
                            .frame(width: geo.size.width - 32, height: (geo.size.width - 32) * 3 / 4)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    SentencesView(externalSentences: externalSentences)
                }
            }
        }
    }
}
