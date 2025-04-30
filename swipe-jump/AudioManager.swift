//
//  AudioManager.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import SpriteKit

class AudioManager {
    // Audio nodes
    private var bounceAudioNode: SKAudioNode?
    private var gameOverAudioNode: SKAudioNode?
    private var targetHitAudioNode: SKAudioNode?
    
    // Reference to parent scene for adding audio nodes
    private weak var scene: SKScene?
    
    init(scene: SKScene) {
        self.scene = scene
        setupSounds()
    }
    
    /// Setup all game sound effects
    private func setupSounds() {
        // Setup audio nodes for all sounds
        if let bounceSoundURL = Bundle.main.url(forResource: "bounce", withExtension: "wav") {
            bounceAudioNode = SKAudioNode(url: bounceSoundURL)
            if let bounceAudioNode = bounceAudioNode, let scene = scene {
                bounceAudioNode.autoplayLooped = false
                scene.addChild(bounceAudioNode)
                bounceAudioNode.run(SKAction.changeVolume(to: 0, duration: 0))
                bounceAudioNode.run(SKAction.pause())
            }
        }
        
        if let gameOverSoundURL = Bundle.main.url(forResource: "gameover", withExtension: "wav") {
            gameOverAudioNode = SKAudioNode(url: gameOverSoundURL)
            if let gameOverAudioNode = gameOverAudioNode, let scene = scene {
                gameOverAudioNode.autoplayLooped = false
                scene.addChild(gameOverAudioNode)
                gameOverAudioNode.run(SKAction.changeVolume(to: 0, duration: 0))
                gameOverAudioNode.run(SKAction.pause())
            }
        }
        
        // Setup audio node for target hit sound
        if let targetHitSoundURL = Bundle.main.url(forResource: "target_hit", withExtension: "wav") {
            targetHitAudioNode = SKAudioNode(url: targetHitSoundURL)
            if let targetHitAudioNode = targetHitAudioNode, let scene = scene {
                targetHitAudioNode.autoplayLooped = false
                scene.addChild(targetHitAudioNode)
                // Initially pause the node
                targetHitAudioNode.run(SKAction.changeVolume(to: 0, duration: 0))
                targetHitAudioNode.run(SKAction.pause())
            }
        }
    }
    
    /// Play the bounce sound effect
    func playBounceSound() {
        if let bounceAudioNode = bounceAudioNode {
            bounceAudioNode.run(SKAction.sequence([
                SKAction.changeVolume(to: 1.0, duration: 0),
                SKAction.play(),
                SKAction.wait(forDuration: 0.3),
                SKAction.pause(),
                SKAction.changeVolume(to: 0, duration: 0)
            ]))
        }
    }
    
    /// Play the game over sound effect
    func playGameOverSound() {
        if let gameOverAudioNode = gameOverAudioNode {
            gameOverAudioNode.run(SKAction.sequence([
                SKAction.changeVolume(to: 1.0, duration: 0),
                SKAction.play(),
                SKAction.wait(forDuration: 2.0),
                SKAction.pause(),
                SKAction.changeVolume(to: 0, duration: 0)
            ]))
        }
    }
    
    /// Play the target hit sound effect
    func playTargetHitSound() {
        if let targetHitAudioNode = targetHitAudioNode {
            targetHitAudioNode.run(SKAction.sequence([
                SKAction.changeVolume(to: 1.0, duration: 0),
                SKAction.play(),
                SKAction.wait(forDuration: 0.5),
                SKAction.pause(),
                SKAction.changeVolume(to: 0, duration: 0)
            ]))
        }
    }
} 