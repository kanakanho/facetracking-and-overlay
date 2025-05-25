//
//  FaceTrackingView.swift
//  facetracking-and-overlay
//
//  Created by blueken on 2025/05/24.
//

import SwiftUI
import ARKit
import SceneKit

struct FaceTrackingView: UIViewRepresentable {
    @ObservedObject var externalFileStorage = ExternalFileStorage<ExternalBlendShapes>()
    
    let arKitSceneView = ARSCNView()

    func makeUIView(context: Context) -> ARSCNView {
        arKitSceneView.delegate = context.coordinator
        arKitSceneView.session.delegate = context.coordinator
        arKitSceneView.automaticallyUpdatesLighting = true
        arKitSceneView.scene = SCNScene()
        
        // ARFaceTrackingConfigurationでセッション開始
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            if #available(iOS 13.0, *) {
                configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
            }
            configuration.isLightEstimationEnabled = true
            arKitSceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
        
        print("finish make makeUIView")
        return arKitSceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        print("updateUIView")
    }
    
    func makeCoordinator() -> Coordinator {
        print("makeCoordinator")
        return Coordinator(self, externalFileStorage: externalFileStorage)
    }
}

class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var parent: FaceTrackingView
    var blendShapeCharacter: BlendShapeCharacter
    
    init(_ parent: FaceTrackingView, externalFileStorage: ExternalFileStorage<ExternalBlendShapes>) {
        self.parent = parent
        self.blendShapeCharacter = BlendShapeCharacter(externalFileStorage: externalFileStorage)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // エラー処理（必要に応じてアラート表示などを追加）
        print(error.localizedDescription)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let contentNode = blendShapeCharacter.renderer(renderer, nodeFor: faceAnchor) else {
            print("contentNode")
            return
        }
        node.addChildNode(contentNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        var contentNode = blendShapeCharacter.contentNode
        if contentNode == nil {
            print("contentNode is nil")
            contentNode = node.childNodes.first
            blendShapeCharacter.contentNode = contentNode
        }
        guard let validContentNode = contentNode else {
            print("contentNode is still nil after checking")
            return
        }
        blendShapeCharacter.renderer(renderer, didUpdate: validContentNode, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    }
}
