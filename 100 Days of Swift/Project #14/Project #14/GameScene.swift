import SpriteKit

class GameScene: SKScene {
    
    let WIDTH = 1024
    let HEIGHT = 768
    
    var popupTime = 0.85
    var numRounds = 0
    
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setupGUI()
        createSlots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
        
        endGame()
    }
    
    func setupGUI() {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 150, y: 8)
        gameScore.fontSize = 48
        addChild(gameScore)
    }
    
    func createSlots() {
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + i * 170, y: 410)) }
        
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + i * 170, y: 320)) }
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + i * 170, y: 230)) }
        
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + i * 170, y: 140)) }
    }
 
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        
        slot.configure(at: position)
        addChild(slot)
        
        slots.append(slot)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if !whackSlot.isVisible || whackSlot.isHit { continue }
            
            whackSlot.hit()
            
            if node.name == "charFriend" {
                onSlotHit(whackSlot, scale: 0.5, score: -5, sound: "whackBad")
            } else if node.name == "charEnemy" {
                onSlotHit(whackSlot, scale: 0.85, score: 1, sound: "whack")
            }
        }
    }
    
    func onSlotHit(_ slot: WhackSlot, scale: Float, score: Int, sound: String) {
        slot.charNode.xScale = CGFloat(scale)
        slot.charNode.yScale = CGFloat(scale)
        
        self.score += score
        
        run(SKAction.playSoundFileNamed(sound + ".caf", waitForCompletion: false))
        
        let effect = SKEmitterNode(fileNamed: "smoke.sks")!
        effect.position = slot.position
        addChild(effect)
    }
    
    
    
    func createEnemy() {
        numRounds += 1
        
        if numRounds >= 30 {
            endGame()
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 { slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
    
    func endGame() {
        slots.forEach {
            $0.hide()
        }
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Final score: \(score)"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: WIDTH / 2, y: HEIGHT / 2 - Int(gameOver.size.height))
        scoreLabel.fontSize = 25
        addChild(scoreLabel)
    }
}
