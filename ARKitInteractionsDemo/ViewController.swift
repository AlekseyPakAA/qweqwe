//
//  ViewController.swift
//  ARKitInteractionsDemo
//
//  Created by Alexey Pak on 31/05/2018.
//  Copyright © 2018 Alexey Pak. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

	/// The view controller that displays the status and "restart experience" UI.
	lazy var statusViewController: StatusViewController = {
		return childViewControllers.lazy.flatMap({ $0 as? StatusViewController }).first!
	}()

	var positionIndicator: SCNNode = {
		let geometry = SCNSphere(radius: 0.01 )
		geometry.firstMaterial?.diffuse.contents  = UIColor.red
		return SCNNode(geometry: geometry)
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
		sceneView.session.delegate = self
        sceneView.autoenablesDefaultLighting = true
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

		statusViewController.message = "FIND A SURFACE TO PLACE AN OBJECT"

		sceneView.scene.rootNode.addChildNode(positionIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal

		sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		DispatchQueue.main.async {
			self.statusViewController.message = "SURFACE DETECTED TAP + TO PLACE AN OBJECT"
		}

		let geometry = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
		let cnode = SCNNode(geometry: geometry)
		cnode.opacity = 1.0
		cnode.eulerAngles.x = -.pi / 2

		node.addChildNode(cnode)
	}

	@IBAction func didTouchAddButton(_ sender: Any) {
		let geometry = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.01)
		let node = SCNNode(geometry: geometry)

		node.simdPosition = positionIndicator.simdPosition
		node.simdPosition.y += Float(geometry.height / 2)

		sceneView.scene.rootNode.addChildNode(node)
	}

	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		guard let geometry = node.childNodes.first?.geometry as? SCNPlane else { return }

		geometry.height = CGFloat(planeAnchor.extent.z)
		geometry.width = CGFloat(planeAnchor.extent.x)
	}


	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		let point = sceneView.center

		guard let transform = sceneView.hitTest(point, types: [.existingPlane]).first?.worldTransform else { return }
		positionIndicator.simdPosition = transform.translation
	}
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
