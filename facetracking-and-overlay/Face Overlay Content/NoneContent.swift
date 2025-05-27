//
//  None.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/27.
//

import ARKit
import SceneKit

class NoneContent: NSObject, VirtualContentController {
    var contentNode: SCNNode?
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return nil
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    }
}
