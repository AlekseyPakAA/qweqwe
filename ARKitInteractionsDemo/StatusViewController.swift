//
//  StatusViewController.swift
//  ARKitInteractionsDemo
//
//  Created by Alexey Pak on 31/05/2018.
//  Copyright © 2018 Alexey Pak. All rights reserved.
//

import Foundation
import UIKit

class StatusViewController: UIViewController {

	@IBOutlet var messageLabel: UILabel?

	var message: String? {
		get {
			return messageLabel?.text
		}
		set {
			messageLabel?.text = newValue
		}
	}
}
