//
//  ContentView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var externalFileStorage = ExternalFileStorage<ExternalBlendShapes>()
    @Environment(\.scenePhase) var scenePhase
    @State var virtualContentType: VirtualContentType = .blendShape
    
    var body: some View {
        VStack {
            Picker("Select Content Type", selection: $virtualContentType) {
                ForEach(VirtualContentType.allCases) { type in
                    Text(type.displayName).tag(type)
                }
            }
            .pickerStyle(.segmented)
                
            FaceTrackingView(virtualContentType: virtualContentType, externalFileStorage: externalFileStorage)
                .edgesIgnoringSafeArea(.all)
                .onDisappear {
                    externalFileStorage.endRecording()
                }
                .id(virtualContentType)
            
            Button(action: {
                externalFileStorage.toggleRecording()
            }) {
                IsRecordingButtonView(externalFileStorage.isRecording)
            }
            .disabled(virtualContentType == .none)
            .opacity(virtualContentType == .none ? 0.3 : 1.0)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                externalFileStorage.endRecording()
            }
        }
    }
}

struct IsRecordingButtonView: View {
    let isRecording: Bool
    
    init(_ isRecording: Bool) {
        self.isRecording = isRecording
    }
    
    var body: some View {
        HStack {
            Image(systemName: isRecording ? "stop.fill" : "play.fill")
                .foregroundColor(isRecording ? .red : .green)
            Text(isRecording ? "Stop" : "Start")
                .font(.title)
                .foregroundColor(isRecording ? .red : .green)
        }
    }
}

#Preview {
    ContentView()
}
