//
//  Node.swift
//  ARKitInteractionsDemo
//
//  Created by Alexey Pak on 31/05/2018.
//  Copyright © 2018 Alexey Pak. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Node: SCNNode {

	init(anchor: ARAnchor) {
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
