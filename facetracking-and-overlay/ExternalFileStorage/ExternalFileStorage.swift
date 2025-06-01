//
//  ExternalFileStorage.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import Foundation
import SceneKit
import ARKit

class ExternalFileStorage<T: Encodable> : ObservableObject {
    private var startUnixTime: Date
    @Published private(set) var isRecording: Bool = false
    private let documentDirectory: URL
    private var fileURL: URL
    private(set) var externalData: [T] = []
    
    init() {
        self.startUnixTime = Date()
        self.documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentDirectory.appendingPathComponent("\(String(describing: T.self))_\(startUnixTime.formattedDate()).json")
    }
    
    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            startUnixTime = Date()
            fileURL = documentDirectory.appendingPathComponent("\(String(describing:  T.self))_\(startUnixTime.formattedDate()).json")
            externalData = []
        } else {
            writeFile()
        }
    }
    
    func endRecording() {
        isRecording = false
        writeFile()
    }
    
    func addData(data: T) {
        if !isRecording {
            return
        }
        externalData.append(data)
    }
    
    private func writeFile() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(externalData)
            try data.write(to: fileURL)
            print("File written to: \(fileURL.path)")
        } catch {
            print("Error writing file: \(error)")
        }
    }
}
