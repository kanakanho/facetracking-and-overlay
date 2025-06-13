//
//  ContentView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI

public enum UserInterfaceSizeClass {
    case compact
    case regular
}

struct ContentView: View {
    @ObservedObject var externalBlendShapes = ExternalFileStorage<ExternalBlendShapes>()
    @ObservedObject var externalSentences = ExternalSentences()
    
    @Environment(\.scenePhase) var scenePhase
    @State var virtualContentType: VirtualContentType = .blendShape
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    
    var body: some View {
        VStack {
            MainView(externalBlendShapes: externalBlendShapes, virtualContentType: $virtualContentType, externalSentences: externalSentences)
            FooterButton(externalSentences: externalSentences)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                externalBlendShapes.endRecording()
                externalSentences.endRecording()
            } else if scenePhase == .active {
                externalBlendShapes.toggleRecording()
            }
        }
    }
}

#Preview {
    ContentView()
}
