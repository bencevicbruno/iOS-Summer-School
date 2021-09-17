import SpriteKit

extension UIColor {
    
    public static func CreateRandom() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1.0)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let colors = ["Red", "Blue", "Cyan", "Yellow", "Grey", "Purple", "Green"]
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            editLabel.text = editingMode ? "Edit" : "Play"
        }
    }
    
    let WIDTH = 1024
    let HEIGHT = 768
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        
        background.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        background.blendMode = .replace
        background.zPosition = -1
        
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        for i in 0..<4 {
            makeSlot(at: CGPoint(x: WIDTH / 8 + WIDTH / 4 * i, y: 0), isGood: i % 2 == 0)
        }
        
        for i in 0..<5 {
            makeBouncer(at: CGPoint(x: WIDTH / 4 * i, y: 0))
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        let postfix = isGood ? "Good" : "Bad"
        
        let slotBase = SKSpriteNode(imageNamed: "slotBase" + postfix)
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        slotBase.name = postfix
        
        let slotGlow = SKSpriteNode(imageNamed: "slotGlow" + postfix)
        slotGlow.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor.CreateRandom(), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else {
                let ball = SKSpriteNode(imageNamed: "ball\(colors.randomElement()!)")
                ball.name = "Ball"
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = location
                addChild(ball)
            }
            
        }
    }

    
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "Good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "Bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        
        if bodyA.name == "Ball" {
            collision(between: bodyA, object: bodyB)
        } else if bodyB.name == "Ball" {
            collision(between: bodyB, object: bodyA)
        }
    }
}
