//
//  GameScene.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    
    // Game elements
    private var ball: SKShapeNode?
    private var ground: SKShapeNode?
    private var scoreLabel: SKLabelNode?
    private var gameOverLabel: SKLabelNode?
    private var leftWall: SKNode?
    private var rightWall: SKNode?
    
    // Manager instances
    private var audioManager: AudioManager!
    private var targetManager: TargetManager!
    private var lineManager: LineManager!
    
    // Line drawing properties
    private var startPoint: CGPoint?
    private var startTouch: UITouch?
    
    // Game state
    private var isGameStarted = false
    private var isGameOver = false
    private var score: Int = 0
    
    // Debug properties
    private var debugMode = false
    
    // MARK: - Lifecycle Methods
    
    override func didMove(to view: SKView) {
        // Initialize managers
        audioManager = AudioManager(scene: self)
        lineManager = LineManager(scene: self)
        targetManager = TargetManager(scene: self, audioManager: audioManager)
        
        setupPhysics()
        setupGameElements()
        targetManager.setupTargets(sceneSize: size)
        
        #if DEBUG
        // Add a debug label for development
        let debugLabel = SKLabelNode(fontNamed: "Arial")
        debugLabel.text = "Debug: Long press for debug mode"
        debugLabel.fontSize = 14
        debugLabel.fontColor = .gray
        debugLabel.position = CGPoint(x: size.width - 100, y: 20)
        debugLabel.horizontalAlignmentMode = .center
        debugLabel.zPosition = 100
        debugLabel.name = "debugLabel"
        addChild(debugLabel)
        
        // Add a long press gesture recognizer for debug mode
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 2.0
        view.addGestureRecognizer(longPress)
        #endif
    }
    
    #if DEBUG
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            debugMode = !debugMode
            if let view = self.view {
                view.showsPhysics = debugMode
            }
            if let debugLabel = childNode(withName: "debugLabel") as? SKLabelNode {
                debugLabel.text = "Debug: \(debugMode ? "ON" : "OFF")"
            }
        }
    }
    #endif
    
    // MARK: - Setup Methods
    
    private func setupPhysics() {
        // Reduced gravity for more bouncy feel
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0) // Reduced from -9.8
        physicsWorld.contactDelegate = self
        
        // Reduce global damping effects
        physicsWorld.speed = 1.0 // Normal speed (can be increased for faster gameplay)
    }
    
    private func setupGameElements() {
        // Setup ball
        ball = GameElementFactory.createBall(at: CGPoint(x: size.width / 2, y: size.height - 100))
        if let ball = ball {
            addChild(ball)
        }
        
        // Setup ground
        ground = GameElementFactory.createGround(
            width: size.width,
            at: CGPoint(x: size.width / 2, y: 10) // Position at bottom of screen
        )
        if let ground = ground {
            addChild(ground)
        }
        
        // Setup score label
        scoreLabel = GameElementFactory.createScoreLabel(at: CGPoint(x: 30, y: size.height - 50))
        if let scoreLabel = scoreLabel {
            addChild(scoreLabel)
        }
        
        // Setup boundaries - add walls that bounce the ball
        setupWalls()
        
        // Add a background
        setupBackground()
    }
    
    private func setupWalls() {
        // Create individual wall nodes instead of using edgeLoop
        
        // Left wall - create a node with physics body
        leftWall = SKNode()
        leftWall?.position = CGPoint(x: 0, y: size.height/2)
        let leftWallBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -size.height/2), to: CGPoint(x: 0, y: size.height/2))
        leftWallBody.isDynamic = false
        leftWallBody.friction = 0.0 // No friction for max bounce
        leftWallBody.restitution = 0.95 // High restitution for more bounce
        leftWallBody.categoryBitMask = PhysicsCategories.edge
        leftWallBody.contactTestBitMask = PhysicsCategories.ball
        leftWallBody.collisionBitMask = PhysicsCategories.ball
        leftWall?.physicsBody = leftWallBody
        
        // Right wall - create a node with physics body
        rightWall = SKNode()
        rightWall?.position = CGPoint(x: size.width, y: size.height/2)
        let rightWallBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: -size.height/2), to: CGPoint(x: 0, y: size.height/2))
        rightWallBody.isDynamic = false
        rightWallBody.friction = 0.0 // No friction for max bounce
        rightWallBody.restitution = 0.95 // High restitution for more bounce
        rightWallBody.categoryBitMask = PhysicsCategories.edge
        rightWallBody.contactTestBitMask = PhysicsCategories.ball
        rightWallBody.collisionBitMask = PhysicsCategories.ball
        rightWall?.physicsBody = rightWallBody
        
        // Add walls to the scene
        if let leftWall = leftWall {
            addChild(leftWall)
        }
        if let rightWall = rightWall {
            addChild(rightWall)
        }
        
        // Top boundary to bounce the ball
        let topWall = SKNode()
        topWall.position = CGPoint(x: size.width/2, y: size.height)
        let topWallBody = SKPhysicsBody(edgeFrom: CGPoint(x: -size.width/2, y: 0), to: CGPoint(x: size.width/2, y: 0))
        topWallBody.isDynamic = false
        topWallBody.friction = 0.0 // No friction for max bounce
        topWallBody.restitution = 0.95 // High restitution for more bounce
        topWallBody.categoryBitMask = PhysicsCategories.edge
        topWallBody.contactTestBitMask = PhysicsCategories.ball
        topWallBody.collisionBitMask = PhysicsCategories.ball
        topWall.physicsBody = topWallBody
        addChild(topWall)
        
        // Visual indicators for walls (for better visibility)
        let leftWallVisual = SKShapeNode(rectOf: CGSize(width: 4, height: size.height))
        leftWallVisual.position = CGPoint(x: 2, y: size.height/2)
        leftWallVisual.fillColor = .blue
        leftWallVisual.strokeColor = .clear
        leftWallVisual.alpha = 0.5
        leftWallVisual.zPosition = -5
        addChild(leftWallVisual)
        
        let rightWallVisual = SKShapeNode(rectOf: CGSize(width: 4, height: size.height))
        rightWallVisual.position = CGPoint(x: size.width - 2, y: size.height/2)
        rightWallVisual.fillColor = .blue
        rightWallVisual.strokeColor = .clear
        rightWallVisual.alpha = 0.5
        rightWallVisual.zPosition = -5
        addChild(rightWallVisual)
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(color: .black, size: self.size)
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = -10
        addChild(background)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Handle game over state
        if isGameOver {
            resetGame()
            return
        }
        
        // Store touch information for line drawing
        startPoint = touch.location(in: self)
        startTouch = touch
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Could implement a preview line visualization here
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, 
              let startPoint = startPoint, 
              touch == startTouch,
              !isGameOver else { return }
        
        let endPoint = touch.location(in: self)
        let lineCreated = lineManager.createLine(from: startPoint, to: endPoint)
        
        if lineCreated {
            updateScore(by: 1) // 1 point for each line drawn
            
            // Start the game if it's not already started
            if !isGameStarted {
                isGameStarted = true
                ball?.physicsBody?.isDynamic = true
                
                // Give the ball a slight initial impulse for better gameplay
                ball?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -5))
            }
        }
        
        // Reset tracking
        self.startPoint = nil
        self.startTouch = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = nil
        startTouch = nil
    }
    
    // MARK: - Game Logic
    
    private func updateScore(by points: Int = 1) {
        score += points
        scoreLabel?.text = "Score: \(score)"
    }
    
    private func showGameOver() {
        // Only trigger game over once
        guard !isGameOver else { return }
        
        isGameOver = true
        
        // Print for debugging
        print("Game Over triggered! Ball position: \(ball?.position.y ?? 0)")
        
        // Remove any existing game over label first
        gameOverLabel?.removeFromParent()
        
        // Create and display game over label
        gameOverLabel = GameElementFactory.createGameOverLabel(
            at: CGPoint(x: size.width / 2, y: size.height / 2)
        )
        
        if let gameOverLabel = gameOverLabel {
            // Start with a scale of 0
            gameOverLabel.setScale(0)
            addChild(gameOverLabel)
            
            // Scale animation
            let scaleAction = SKAction.scale(to: 1.0, duration: 0.3)
            gameOverLabel.run(scaleAction)
            
            // Play game over sound
            audioManager.playGameOverSound()
            
            // Make sure the ball stops
            ball?.physicsBody?.velocity = .zero
            ball?.physicsBody?.isDynamic = false
        }
    }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        // Only doing ball position debugging here now
        if let ball = ball, debugMode {
            if let debugLabel = childNode(withName: "debugLabel") as? SKLabelNode {
                debugLabel.text = "Ball: \(Int(ball.position.x)),\(Int(ball.position.y))"
            }
        }
        
        // Safety check - if ball somehow gets outside the bounds, bring it back
        if let ball = ball, !isGameOver {
            let margin: CGFloat = 20.0
            
            // Check if ball is too far off screen and reset its position
            if ball.position.x < -margin || ball.position.x > size.width + margin {
                print("Ball out of bounds! Resetting position: \(ball.position.x)")
                ball.position.x = min(max(ball.position.x, 20), size.width - 20)
                
                // Fix the optional unwrapping issue
                if let physicsBody = ball.physicsBody {
                    // Safely unwrap and reverse the velocity
                    physicsBody.velocity.dx = -physicsBody.velocity.dx
                }
            }
        }
    }
    
    // MARK: - Game State Management
    
    private func resetGame() {
        // Reset ball position and physics
        ball?.position = CGPoint(x: size.width / 2, y: size.height - 100)
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        ball?.physicsBody?.isDynamic = false
        
        // Remove all lines
        lineManager.removeAllLines()
        
        // Reset score
        score = 0
        scoreLabel?.text = "Score: 0"
        
        // Reset targets
        targetManager.resetTargets(sceneSize: size)
        
        // Remove game over label
        gameOverLabel?.removeFromParent()
        gameOverLabel = nil
        
        // Reset game state
        isGameStarted = false
        isGameOver = false
    }
    
    // MARK: - Physics Contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Identify which bodies collided
        let collision = bodyA.categoryBitMask | bodyB.categoryBitMask
        
        // Check if the ball hit the ground
        if collision == PhysicsCategories.ball | PhysicsCategories.ground {
            showGameOver()
            return
        }
        
        // Check if the ball hit a target
        if collision == PhysicsCategories.ball | PhysicsCategories.target {
            // Find the target node
            let targetNode = (bodyA.categoryBitMask == PhysicsCategories.target) ? bodyA.node : bodyB.node
            
            if let target = targetNode {
                targetManager.handleTargetHit(target) { points in
                    self.updateScore(by: points)
                }
            }
        }
        
        // Check if the ball hit a line or edge
        if collision == PhysicsCategories.ball | PhysicsCategories.line || 
           collision == PhysicsCategories.ball | PhysicsCategories.edge {
            // Play bounce sound
            audioManager.playBounceSound()
            
            // Add a visual effect where the collision occurred
            if let contactPoint = contact.contactPoint as CGPoint? {
                // Create a simple visual effect
                let sparkNode = SKShapeNode(circleOfRadius: 5)
                sparkNode.fillColor = .white
                sparkNode.position = contactPoint
                sparkNode.zPosition = 3
                addChild(sparkNode)
                
                // Remove sparkNode after a short time
                let fadeOut = SKAction.fadeOut(withDuration: 0.3)
                let remove = SKAction.removeFromParent()
                sparkNode.run(SKAction.sequence([fadeOut, remove]))
                
                // Apply a small extra impulse on bounce for even more bounce effect
                let ballBody = contact.bodyA.categoryBitMask == PhysicsCategories.ball ? contact.bodyA : contact.bodyB
                let normal = contact.contactNormal
                
                // Apply a small impulse in the direction of the normal
                ballBody.applyImpulse(CGVector(dx: normal.dx * 2, dy: normal.dy * 2))
            }
        }
    }
}
