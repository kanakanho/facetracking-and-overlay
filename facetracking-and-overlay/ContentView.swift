//
//  ContentView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var externalFileStorage = ExternalFileStorage<ExternalBlendShapes>()
    
    var body: some View {
        VStack {
            FaceTrackingView(externalFileStorage: externalFileStorage)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Button(action: {
                    externalFileStorage.toggleRecording()
                }) {
                    IsRecordingButtonView(externalFileStorage.isRecording)
                }
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
