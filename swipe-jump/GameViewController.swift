//
//  GameViewController.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Create a new scene programmatically instead of loading from file
            let scene = GameScene(size: view.bounds.size)
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            // Debug information
            #if DEBUG
            view.showsFPS = true
            view.showsNodeCount = true
            view.showsPhysics = false // Set to true for physics debugging
            #endif
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Support only portrait mode for this game
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Disable screen dimming during gameplay
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .all
    }
}
