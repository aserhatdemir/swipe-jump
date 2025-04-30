//
//  TargetManager.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import SpriteKit

class TargetManager {
    // Target tracking
    private var targets: [SKShapeNode] = []
    private var hitTargets: Set<SKNode> = []
    
    // Reference to parent scene for adding targets
    private weak var scene: SKScene?
    
    // Audio manager reference
    private let audioManager: AudioManager
    
    init(scene: SKScene, audioManager: AudioManager) {
        self.scene = scene
        self.audioManager = audioManager
    }
    
    /// Setup all targets in the game
    func setupTargets(sceneSize: CGSize) {
        guard let scene = scene else { return }
        
        // Create 3 targets on the left wall
        let leftTargetPositions = [
            CGPoint(x: 20, y: sceneSize.height * 0.25),
            CGPoint(x: 20, y: sceneSize.height * 0.5),
            CGPoint(x: 20, y: sceneSize.height * 0.75)
        ]
        
        // Create 3 targets on the right wall
        let rightTargetPositions = [
            CGPoint(x: sceneSize.width - 20, y: sceneSize.height * 0.25),
            CGPoint(x: sceneSize.width - 20, y: sceneSize.height * 0.5),
            CGPoint(x: sceneSize.width - 20, y: sceneSize.height * 0.75)
        ]
        
        // Create and add all targets
        for position in leftTargetPositions + rightTargetPositions {
            let target = GameElementFactory.createTarget(at: position)
            scene.addChild(target)
            targets.append(target)
        }
    }
    
    /// Handle a target being hit by the ball
    func handleTargetHit(_ target: SKNode, updateScore: (Int) -> Void) {
        // Don't count targets more than once
        guard !hitTargets.contains(target) else { return }
        
        // Play hit sound
        audioManager.playTargetHitSound()
        
        // Visual feedback for hit - first flash, then disappear
        let flash = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.2, duration: 0.1),
            SKAction.fadeAlpha(to: 1.0, duration: 0.1)
        ])
        
        // Disappearing effect - scale down and fade out
        let scaleDown = SKAction.scale(to: 0.1, duration: 0.3)
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        
        // Run the sequence of effects
        let effectSequence = SKAction.sequence([
            SKAction.repeat(flash, count: 2),
            SKAction.group([scaleDown, fadeOut]),
            remove
        ])
        
        target.run(effectSequence)
        
        // Show bonus points
        if let scene = scene {
            let bonusLabel = GameElementFactory.createBonusLabel(
                at: target.position,
                points: GameConfig.targetBonusPoints
            )
            scene.addChild(bonusLabel)
            
            // Animate the bonus label upward and fade out
            let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.8)
            let labelFadeOut = SKAction.fadeOut(withDuration: 0.8)
            let labelRemove = SKAction.removeFromParent()
            bonusLabel.run(SKAction.sequence([
                SKAction.group([moveUp, labelFadeOut]),
                labelRemove
            ]))
        }
        
        // Add points to score
        updateScore(GameConfig.targetBonusPoints)
        
        // Mark target as hit
        hitTargets.insert(target)
    }
    
    /// Reset all targets for a new game
    func resetTargets(sceneSize: CGSize) {
        guard let scene = scene else { return }
        
        // Clear the hit targets tracking
        hitTargets.removeAll()
        
        // Remove any remaining targets from the scene
        for target in targets {
            target.removeFromParent()
        }
        targets.removeAll()
        
        // Recreate all targets
        setupTargets(sceneSize: sceneSize)
    }
    
    /// Get all targets for collision detection
    var allTargets: [SKShapeNode] {
        return targets
    }
} 