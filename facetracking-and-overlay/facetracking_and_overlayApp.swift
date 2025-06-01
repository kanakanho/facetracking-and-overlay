//
//  facetracking_and_overlayApp.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI

@main
struct facetracking_and_overlayApp: App {
    @ObservedObject var externalBlendShapes = ExternalFileStorage<ExternalBlendShapes>()
    @ObservedObject var externalSentences = ExternalSentences()
    
    var body: some Scene {
        WindowGroup {
            ContentView(externalBlendShapes: externalBlendShapes, externalSentences: externalSentences)
        }
    }
}
