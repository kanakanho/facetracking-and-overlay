//
//  facetracking_and_overlayApp.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI

@main
struct facetracking_and_overlayApp: App {
    @ObservedObject var externalFileStorage = ExternalFileStorage<ExternalBlendShapes>()
    var body: some Scene {
        WindowGroup {
            ContentView(externalFileStorage: externalFileStorage)
        }
    }
}
