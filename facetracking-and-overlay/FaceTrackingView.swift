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
    let externalBlendShapes:  ExternalFileStorage<ExternalBlendShapes>
    var virtualContentType: VirtualContentType
    var coordinators: [VirtualContentType: Coordinator]
    
    init(virtualContentType: VirtualContentType ,externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>) {
        self.virtualContentType = virtualContentType
        self.externalBlendShapes = externalBlendShapes
        self.coordinators = [:]
        self.coordinators[.none] = NoneContentCoordinator(self)
        self.coordinators[.blendShape] = BlendShapeCoordinator(self, externalBlendShapes: externalBlendShapes)
    }
    
    func makeCoordinator() -> Coordinator {
        return coordinators[virtualContentType]!
    }
    
    func makeUIView(context: Context) -> ARSCNView {
        let arKitSceneView = ARSCNView()
        arKitSceneView.delegate = context.coordinator
        arKitSceneView.session.delegate = context.coordinator
        arKitSceneView.automaticallyUpdatesLighting = true
        arKitSceneView.scene = SCNScene()
        
        if ARFaceTrackingConfiguration.isSupported {
            let configuration = ARFaceTrackingConfiguration()
            if #available(iOS 13.0, *) {
                configuration.maximumNumberOfTrackedFaces = ARFaceTrackingConfiguration.supportedNumberOfTrackedFaces
            }
            configuration.isLightEstimationEnabled = true
            arKitSceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
        
        return arKitSceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // coordinator のアップデート
    }
}

class NoneContentCoordinator: NSObject, Coordinator {
    var parent: FaceTrackingView
    var noneContent: NoneContent
    
    init(_ parent: FaceTrackingView) {
        self.parent = parent
        self.noneContent = NoneContent()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // エラー処理（必要に応じてアラート表示などを追加）
        print(error.localizedDescription)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        guard let contentNode = noneContent.renderer(renderer, nodeFor: faceAnchor) else {
            print("contentNode")
            return
        }
        node.addChildNode(contentNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        var contentNode = noneContent.contentNode
        if contentNode == nil {
            print("contentNode is nil")
            contentNode = node.childNodes.first
            noneContent.contentNode = contentNode
        }
        guard let validContentNode = contentNode else {
            print("contentNode is still nil after checking")
            return
        }
        noneContent.renderer(renderer, didUpdate: validContentNode, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    }
}

class BlendShapeCoordinator: NSObject, Coordinator {
    var parent: FaceTrackingView
    var blendShapeCharacter: BlendShapeCharacter
    
    init(_ parent: FaceTrackingView, externalBlendShapes: ExternalFileStorage<ExternalBlendShapes>) {
        self.parent = parent
        self.blendShapeCharacter = BlendShapeCharacter(externalBlendShapes: externalBlendShapes)
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

protocol Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var parent: FaceTrackingView { get }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)
    
    func session(_ session: ARSession, didFailWithError error: Error)
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor)
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor)
}
