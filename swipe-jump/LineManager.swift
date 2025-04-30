//
//  LineManager.swift
//  swipe-jump
//
//  Created by Serhat Demir on 21.04.2025.
//

import SpriteKit

class LineManager {
    // Line drawing properties
    private var lineNodes: [SKShapeNode] = []
    
    // Reference to parent scene for adding lines
    private weak var scene: SKScene?
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    /// Create a line between two points
    @discardableResult
    func createLine(from startPoint: CGPoint, to endPoint: CGPoint) -> Bool {
        guard let scene = scene else { return false }
        
        // Only create a line if the swipe has some minimum length
        let distance = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
        guard distance > GameConfig.minSwipeLength else { return false }
        
        // Create a simple line shape
        let line = SKShapeNode()
        let path = CGMutablePath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: distance, y: 0))
        line.path = path
        
        // Position and rotate the line to match the swipe
        line.position = startPoint
        line.zRotation = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        
        // Style the line
        line.strokeColor = .white
        line.lineWidth = 5
        line.name = "line"
        
        // Physics for the line
        let physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: distance, height: 5), center: CGPoint(x: distance/2, y: 0))
        physicsBody.isDynamic = false
        physicsBody.affectedByGravity = false
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0.95 // Increased for more bounce
        physicsBody.friction = 0.0 // No friction for max bounce
        physicsBody.categoryBitMask = PhysicsCategories.line
        physicsBody.contactTestBitMask = PhysicsCategories.ball
        physicsBody.collisionBitMask = PhysicsCategories.ball
        
        line.physicsBody = physicsBody
        
        // Add the line to the scene
        scene.addChild(line)
        lineNodes.append(line)
        
        // Add a fade-out effect
        let fadeOut = SKAction.fadeOut(withDuration: GameConfig.lineLifetime)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        
        line.run(sequence) { [weak self] in
            if let index = self?.lineNodes.firstIndex(of: line) {
                self?.lineNodes.remove(at: index)
            }
        }
        
        // Manage line count to prevent memory issues
        if lineNodes.count > GameConfig.maxLineCount {
            if let oldestLine = lineNodes.first {
                oldestLine.removeFromParent()
                lineNodes.removeFirst()
            }
        }
        
        return true
    }
    
    /// Remove all lines from the scene
    func removeAllLines() {
        for line in lineNodes {
            line.removeFromParent()
        }
        lineNodes.removeAll()
    }
    
    /// Get the count of current lines
    var lineCount: Int {
        return lineNodes.count
    }
} 