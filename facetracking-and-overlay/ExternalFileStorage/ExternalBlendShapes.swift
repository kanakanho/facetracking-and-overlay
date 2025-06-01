//
//  ExternalBlendShapes.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/31.
//

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
