//
//  ExternalFileStorage.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import Foundation
import SceneKit
import ARKit

struct ExternalBlendShapes: Encodable {
    var timestamp: Date
    var blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber] = [:]
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case blendShapes
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let blendShapeDict: [String: Double] = blendShapes.reduce(into: [:]) { result, pair in
            result[pair.key.rawValue] = pair.value.doubleValue
        }
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(blendShapeDict, forKey: .blendShapes)
    }
}

// Utility extension to convert dictionary keys
extension Dictionary {
    func mapKeys<T>(_ transform: (Key) throws -> T) rethrows -> [T: Value] where T: Hashable {
        var newDict: [T: Value] = [:]
        for (key, value) in self {
            newDict[try transform(key)] = value
        }
        return newDict
    }
}

class ExternalFileStorage<T: Encodable> : ObservableObject {
    private var startUnixTime: Date
    @Published private(set) var isRecording: Bool = false
    private let documentDirectory: URL
    private var fileURL: URL
    private var externalData: [T] = []
    
    init() {
        self.startUnixTime = Date()
        self.documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.fileURL = documentDirectory.appendingPathComponent("\(startUnixTime.formattedDate()).json")
    }
    
    func toggleRecording() {
        isRecording.toggle()
        if isRecording {
            startUnixTime = Date()
            fileURL = documentDirectory.appendingPathComponent("\(startUnixTime.formattedDate()).json")
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

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        return formatter.string(from: self)
    }
}
