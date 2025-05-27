/*
 Copyright © 2024 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
//
//  VirtualContentController.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import ARKit
import SceneKit

enum VirtualContentType: Int, CaseIterable, Identifiable {
    case none, blendShape
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .none:
            return "None"
        case .blendShape:
            return "Blend Shape"
        }
    }
    
    func makeController() -> VirtualContentController {
        switch self {
        case .none:
            return NoneContent()
        case .blendShape:
            return BlendShapeCharacter(externalFileStorage: ExternalFileStorage<ExternalBlendShapes>())
        }
    }
}

/// For forwarding `ARSCNViewDelegate` messages to the object controlling the currently visible virtual content.
protocol VirtualContentController: ARSCNViewDelegate {
    /// The root node for the virtual content.
    var contentNode: SCNNode? { get set }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode?
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
}
