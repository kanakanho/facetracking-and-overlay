/*
 Copyright © 2024 Apple Inc.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import SceneKit
import ARKit
import SwiftUI

/// - Tag: BlendShapeCharacter
class BlendShapeCharacter: NSObject, VirtualContentController {
    @ObservedObject var externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>
    
    init(externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>) {
        self.externalBlendShapes = externalBlendShapes
        super.init()
    }
    
    var contentNode: SCNNode?
    
    private var jawNode: SCNNode?
    private var eyeLeftNode: SCNNode?
    private var eyeRightNode: SCNNode?
    
    private var originalJawY: Float = 0
    private var jawHeight: Float = 0
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else {
            print("not ARFaceAnchor")
            return nil
        }
        
        let contentNode = SCNReferenceNode(named: "robotHead")
        
        jawNode = contentNode.childNode(withName: "jaw", recursively: true)
        eyeLeftNode = contentNode.childNode(withName: "eyeLeft", recursively: true)
        eyeRightNode = contentNode.childNode(withName: "eyeRight", recursively: true)
        
        if let jaw = jawNode {
            originalJawY = jaw.position.y
            let (min, max) = jaw.boundingBox
            jawHeight = max.y - min.y
        }
        
        // Assign a random color to the eyes.
        let eyeMaterial = SCNMaterial.materialWithColor(UIColor(white: 0.9, alpha: 0.7))
        let jawMaterial = SCNMaterial.materialWithColor(UIColor(white: 0.5, alpha: 0.7))
        contentNode.childNode(withName: "eyeLeft", recursively: true)?.geometry?.materials = [eyeMaterial]
        contentNode.childNode(withName: "eyeRight", recursively: true)?.geometry?.materials = [eyeMaterial]
        contentNode.childNode(withName: "jaw", recursively: true)?.geometry?.materials = [jawMaterial]
        contentNode.childNode(withName: "head", recursively: true)?.geometry?.materials = [jawMaterial]
        
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            print("not ARFaceAnchor in didUpdate")
            return
        }
        
        let blendShapes = faceAnchor.blendShapes
        let timestamp = Date()
        let blendShapeData = ExternalBlendShapes(timestamp: timestamp, blendShapes: blendShapes)
        externalBlendShapes.addData(data: blendShapeData)
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float,
              let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float,
              let jawOpen = blendShapes[.jawOpen] as? Float
        else {
            print("Failed to get blend shapes")
            return
        }
        
        eyeLeftNode?.scale.z = 1 - eyeBlinkLeft
        eyeRightNode?.scale.z = 1 - eyeBlinkRight
        if let jaw = jawNode {
            jaw.position.y = originalJawY - jawHeight * jawOpen
        }
    }
}
