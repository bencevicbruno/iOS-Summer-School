//
//  GameScene.swift
//  Project #17
//
//  Created by Bruno Benčević on 8/13/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameTimer: Timer?
    var isGameOver = false
    
    var enemiesMade = 0
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var lastTouch: UITouch!
    
    override func didMove(to view: SKView) {
        setup()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
    
    func setup() {
        self.backgroundColor = .black
        
        starField = SKEmitterNode(fileNamed: "starfield")!
        starField.position = CGPoint(x: 1024, y: 384)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody!.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
    }
    
    @objc func createEnemy() {
        if isGameOver { return }
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        self.addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody!.categoryBitMask = 1
        sprite.physicsBody!.velocity = CGVector(dx: -500, dy: 0)
        sprite.physicsBody!.angularVelocity = 5
        sprite.physicsBody!.linearDamping = 0
        sprite.physicsBody!.angularDamping = 0
        
        enemiesMade += 1
        if enemiesMade == 20 {
            var newInterval = gameTimer!.timeInterval - 0.1
            if newInterval < 0.1 {
                newInterval = 0.1
            }
            
            gameTimer!.invalidate()
            gameTimer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.children.filter{$0.position.x < -300}.forEach{
            $0.removeFromParent()
            
            if !isGameOver {
                score += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        if let lastTouch = lastTouch {
            if touch.location(in: self).distanceTo(lastTouch.location(in: self)) > 100 {
                return
            }
        }
        
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        lastTouch = touch
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        isGameOver = true
    }
}

extension CGPoint {
    func distanceTo(_ point: CGPoint) -> Float {
        return Float(sqrt(pow(x - point.x, 2) + pow(y - point.y, 2)))
    }
}
