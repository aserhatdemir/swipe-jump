//
//  GameElements.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import SpriteKit

/// A utility class for creating and managing game elements
class GameElementFactory {
    
    /// Creates a ball node with proper physics configuration
    static func createBall(at position: CGPoint, radius: CGFloat = 15.0) -> SKShapeNode {
        let ball = SKShapeNode(circleOfRadius: radius)
        ball.fillColor = .red
        ball.strokeColor = .red
        ball.position = position
        ball.name = "ball"
        
        // Physics setup for the ball
        let physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody.isDynamic = true
        physicsBody.allowsRotation = true
        physicsBody.restitution = 0.95 // Increased bounciness (was 0.7)
        physicsBody.friction = 0.1 // Decreased friction to bounce more
        physicsBody.linearDamping = 0.1 // Decreased damping for more bounce
        physicsBody.angularDamping = 0.1 // Decreased angular damping
        physicsBody.categoryBitMask = PhysicsCategories.ball
        physicsBody.contactTestBitMask = PhysicsCategories.line | PhysicsCategories.edge | PhysicsCategories.ground | PhysicsCategories.target
        physicsBody.collisionBitMask = PhysicsCategories.line | PhysicsCategories.edge | PhysicsCategories.ground | PhysicsCategories.target
        
        ball.physicsBody = physicsBody
        
        return ball
    }
    
    /// Creates a target that awards bonus points when hit
    static func createTarget(at position: CGPoint, size: CGSize = CGSize(width: 30, height: 30)) -> SKShapeNode {
        // Create a circular target
        let target = SKShapeNode(circleOfRadius: size.width / 2)
        target.fillColor = .yellow
        target.strokeColor = .orange
        target.lineWidth = 2
        target.position = position
        target.name = "target"
        target.zPosition = 5
        
        // Add a pulsing animation to make targets more visible
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        let pulseContinuously = SKAction.repeatForever(pulse)
        target.run(pulseContinuously)
        
        // Add a physics body for collision detection
        let physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.categoryBitMask = PhysicsCategories.target
        physicsBody.contactTestBitMask = PhysicsCategories.ball
        physicsBody.collisionBitMask = PhysicsCategories.ball
        physicsBody.restitution = 1.0 // Perfect bounce
        
        target.physicsBody = physicsBody
        
        return target
    }
    
    /// Creates a ground node with collision detection for game over
    static func createGround(width: CGFloat, at position: CGPoint) -> SKShapeNode {
        let ground = SKShapeNode(rectOf: CGSize(width: width, height: 10))
        ground.fillColor = .red
        ground.strokeColor = .clear
        ground.position = position
        ground.name = "ground"
        ground.alpha = 0.3 // Semi-transparent for visual feedback
        
        // Physics for the ground
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: 10))
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.restitution = 0.0 // No bounce
        physicsBody.friction = 1.0 // High friction
        physicsBody.categoryBitMask = PhysicsCategories.ground
        physicsBody.contactTestBitMask = PhysicsCategories.ball
        physicsBody.collisionBitMask = PhysicsCategories.ball
        
        ground.physicsBody = physicsBody
        
        return ground
    }
    
    /// Creates a line node between two points with proper physics configuration
    static func createLine(from startPoint: CGPoint, to endPoint: CGPoint) -> SKShapeNode {
        // Create a simple path for the line
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let line = SKShapeNode(path: path)
        line.strokeColor = .white
        line.lineWidth = 5
        line.name = "line"
        line.position = .zero // Set position to origin as path already contains absolute coordinates
        
        // Create a physics body that follows the path
        let distance = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
        let midX = (startPoint.x + endPoint.x) / 2
        let midY = (startPoint.y + endPoint.y) / 2
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: distance, height: 5), center: CGPoint(x: midX, y: midY))
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.95 // Increased bounciness (was 0.7)
        physicsBody.friction = 0.1 // Decreased friction to bounce more
        physicsBody.categoryBitMask = PhysicsCategories.line
        physicsBody.contactTestBitMask = PhysicsCategories.ball
        physicsBody.collisionBitMask = PhysicsCategories.ball
        
        line.physicsBody = physicsBody
        
        return line
    }
    
    /// Creates a score label
    static func createScoreLabel(at position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.text = "Score: 0"
        label.fontSize = 24
        label.fontColor = .white
        label.position = position
        label.horizontalAlignmentMode = .left
        label.zPosition = 10 // Ensure it's above other elements
        
        return label
    }
    
    /// Creates a bonus points indicator
    static func createBonusLabel(at position: CGPoint, points: Int) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.text = "+\(points)"
        label.fontSize = 20
        label.fontColor = .yellow
        label.position = position
        label.horizontalAlignmentMode = .center
        label.zPosition = 11
        
        return label
    }
    
    /// Creates a game over label
    static func createGameOverLabel(at position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.text = "Game Over! Tap to Restart"
        label.fontSize = 30
        label.fontColor = .white
        label.position = position
        label.horizontalAlignmentMode = .center
        label.zPosition = 100 // Very high z-index to ensure visibility
        
        // Add a background for better visibility
        let background = SKShapeNode(rectOf: CGSize(width: 350, height: 60), cornerRadius: 10)
        background.fillColor = .black
        background.alpha = 0.7
        background.zPosition = 99 // Just below the text
        
        label.addChild(background)
        
        return label
    }
}

/// Physics categories for collision detection
struct PhysicsCategories {
    static let none: UInt32 = 0
    static let ball: UInt32 = 0x1
    static let line: UInt32 = 0x1 << 1
    static let edge: UInt32 = 0x1 << 2
    static let ground: UInt32 = 0x1 << 3
    static let target: UInt32 = 0x1 << 4
}

/// Game configuration constants
struct GameConfig {
    static let lineLifetime: TimeInterval = 3.0
    static let minSwipeLength: CGFloat = 20.0
    static let maxLineCount: Int = 20
    static let ballResetHeight: CGFloat = 0.0 // Changed from -50 to 0 to detect falling off screen sooner
    static let targetBonusPoints: Int = 5 // Points awarded for hitting a target
}