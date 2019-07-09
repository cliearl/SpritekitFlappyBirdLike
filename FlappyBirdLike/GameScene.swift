//
//  GameScene.swift
//  FlappyBirdLike
//
//  Created by Kyunghun Jung on 22/05/2019.
//  Copyright © 2019 qualitybits.net. All rights reserved.
//

import SpriteKit

enum GameState {
    case ready
    case playing
    case dead
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background = SKSpriteNode()
    var tutorial = SKSpriteNode()
    
    let cameraNode = SKCameraNode()
    var bgmPlayer = SKAudioNode()
    var bird = SKSpriteNode()
    var gameState = GameState.ready {
        didSet {
            print(gameState)
        }
    }
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var scoreLabel = SKLabelNode()

    // MARK: - Sprites Alignment
    override func didMove(to view: SKView) {
        let bgColor = SKColor(red: 81.0 / 255.0, green: 192.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        createBird()
        createEnvironment()
        createScore()
        createRain()
        createTutorial()
        
        // BGM 모듈
        bgmPlayer = SKAudioNode(fileNamed: "bgm.mp3")
        bgmPlayer.autoplayLooped = true
        self.addChild(bgmPlayer)
        
        // 카메라 추가
        camera = cameraNode
        cameraNode.position.x = self.size.width / 2
        cameraNode.position.y = self.size.height / 2
        self.addChild(cameraNode)
    }
    
    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Minercraftory")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: self.size.width / 2,
                                      y: self.size.height - 60)
        scoreLabel.zPosition = Layer.hud
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.text = "\(score)"
        addChild(scoreLabel)
    }
    
    func createBird() {        
        bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width / 4, y: self.size.height / 2)
        bird.zPosition = Layer.bird
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height / 2)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling | PhysicsCategory.score
        bird.physicsBody?.collisionBitMask = PhysicsCategory.land | PhysicsCategory.pipe | PhysicsCategory.ceiling
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = false
        addChild(bird)
        
        guard let flyingBySKS = SKAction(named: "flying") else { return }
        bird.run(flyingBySKS)
        
        // thruster 효과 추가
        guard let thruster = SKEmitterNode(fileNamed: "thruster") else { return }
        thruster.position = CGPoint.zero
        thruster.position.x -= bird.size.width / 2
        thruster.zPosition = -0.1
        // Add 블렌딩 문제를 SKEffectNode로 해결
        let thrusterEffectNode = SKEffectNode()
        thrusterEffectNode.addChild(thruster)
        bird.addChild(thrusterEffectNode)
    }
    
    func createEnvironment() {
        let envAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = envAtlas.textureNamed("land")
        let landRepeatNum = Int(ceil(self.size.width / landTexture.size().width))
//        let skyTexture = envAtlas.textureNamed("sky")
        guard let skyTexture = self.background.texture else { return }
        let skyRepeatNum = Int(ceil(self.size.width / skyTexture.size().width))
        let ceilTexture = envAtlas.textureNamed("ceiling")
        let ceilRepearNum = Int(ceil(self.size.width / ceilTexture.size().width))
        
        for i in 0...landRepeatNum {
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = Layer.land
            
            land.physicsBody = SKPhysicsBody(rectangleOf: land.size,
                                             center: CGPoint(x: land.size.width / 2,
                                                             y: land.size.height / 2))
            land.physicsBody?.categoryBitMask = PhysicsCategory.land
            land.physicsBody?.affectedByGravity = false
            land.physicsBody?.isDynamic = false
            addChild(land)
            
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width,
                                           y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: landTexture.size().width,
                                            y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            land.run(SKAction.repeatForever(moveSequence))
        }
        
        for i in 0...skyRepeatNum {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
//            sky.position = CGPoint(x: CGFloat(i) * sky.size.width,
//                                   y: envAtlas.textureNamed("land").size().height)
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: 0)
            sky.zPosition = Layer.sky
            addChild(sky)
            
            let moveLeft = SKAction.moveBy(x: -skyTexture.size().width,
                                           y: 0, duration: 40)
            let moveReset = SKAction.moveBy(x: skyTexture.size().width,
                                            y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            sky.run(SKAction.repeatForever(moveSequence))
        }
        
        for i in 0...ceilRepearNum {
            let ceiling = SKSpriteNode(texture: ceilTexture)
            ceiling.anchorPoint = CGPoint.zero
            ceiling.position = CGPoint(x: CGFloat(i) * ceiling.size.width,
                                       y: self.size.height - ceiling.size.height / 2)
            ceiling.zPosition = Layer.ceiling
            
            ceiling.physicsBody = SKPhysicsBody(rectangleOf: ceiling.size,
                                                center: CGPoint(x: ceiling.size.width / 2,
                                                                y: ceiling.size.height / 2))
            ceiling.physicsBody?.categoryBitMask = PhysicsCategory.ceiling
            ceiling.physicsBody?.affectedByGravity = false
            ceiling.physicsBody?.isDynamic = false
            addChild(ceiling)
            
            let moveLeft = SKAction.moveBy(x: -ceilTexture.size().width, y: 0, duration: 3)
            let moveReset = SKAction.moveBy(x: ceilTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            ceiling.run(SKAction.repeatForever(moveSequence))
        }
    }
    
    func setupPipe(pipeDistance:CGFloat) {
        // 스프라이트 생성
        let envAtlas = SKTextureAtlas(named: "Environment")
        let pipeTexture = envAtlas.textureNamed("pipe")
        
        let pipeDown = SKSpriteNode(texture: pipeTexture)
        pipeDown.zPosition = Layer.pipe
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeDown.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        pipeDown.physicsBody?.isDynamic = false
        
        let pipeUp = SKSpriteNode(texture: pipeTexture)
        pipeUp.xScale = -1
        pipeUp.zRotation = .pi
        pipeUp.zPosition = Layer.pipe
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipeUp.physicsBody?.categoryBitMask = PhysicsCategory.pipe
        pipeUp.physicsBody?.isDynamic = false
        
        let pipeCollision = SKSpriteNode(color: UIColor.red,
                                         size: CGSize(width: 1, height: self.size.height))
        pipeCollision.zPosition = Layer.pipe
        pipeCollision.physicsBody = SKPhysicsBody(rectangleOf: pipeCollision.size)
        pipeCollision.physicsBody?.categoryBitMask = PhysicsCategory.score
        pipeCollision.physicsBody?.isDynamic = false
        pipeCollision.name = "pipeCollision"
        
        addChild(pipeDown)
        addChild(pipeUp)
        addChild(pipeCollision)
        
        
        // 스프라이트 배치
        let max = self.size.height * 0.3
        let xPos = self.size.width + pipeUp.size.width
        let yPos = CGFloat(arc4random_uniform(UInt32(max)))
            + envAtlas.textureNamed("land").size().height
        let endPos = self.size.width + (pipeDown.size.width * 2)
        
        pipeDown.position = CGPoint(x: xPos, y: yPos)
        pipeUp.position = CGPoint(x: xPos,
                                  y: pipeDown.position.y + pipeDistance + pipeUp.size.height)
        pipeCollision.position = CGPoint(x: xPos, y: self.size.height / 2)
        
        let moveAct = SKAction.moveBy(x: -endPos, y: 0, duration: 6)
        let moveSeq = SKAction.sequence([moveAct, SKAction.removeFromParent()])
        pipeDown.run(moveSeq)
        pipeUp.run(moveSeq)
        pipeCollision.run(moveSeq)
    }
    
    func createInfinitePipe(duration:TimeInterval) {
        let create = SKAction.run { [unowned self] in
            self.setupPipe(pipeDistance: 100)
        }
        
        let wait = SKAction.wait(forDuration: duration)
        let actSeq = SKAction.sequence([create, wait])
        run(SKAction.repeatForever(actSeq))
    }
    
    func createTutorial() {
        tutorial = SKSpriteNode(imageNamed: "tutorial")
        tutorial.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        tutorial.zPosition = Layer.tutorial
        addChild(tutorial)
    }
    
    // MARK: - Game Algorithm
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gameState {
        case .ready:
            gameState = .playing
            
            self.bird.physicsBody?.isDynamic = true
            self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
            self.createInfinitePipe(duration: 4)
            
            let fadeOut = SKAction.fadeOut(withDuration: 0.5)
            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()
            let actSequence = SKAction.sequence([fadeOut, wait, remove])
            self.tutorial.run(actSequence)
            
        case .playing:
            self.run(SoundFX.wing)
            self.bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 7))
        case .dead:
            let touch = touches.first
            if let location = touch?.location(in: self) {
                let nodesArray = self.nodes(at: location)
                if nodesArray.first?.name == "restartBtn" {
                    self.run(SoundFX.swooshing)
                    let scene = MenuScene(size: self.size)
                    let transition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var collideBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            collideBody = contact.bodyB
        } else {
            collideBody = contact.bodyA
        }
        
        let collideType = collideBody.categoryBitMask
        switch collideType {
        case PhysicsCategory.land:
            print("land!")
            if gameState == .playing {
                gameOver()
            }
        case PhysicsCategory.ceiling:
            print("ceiling!")
        case PhysicsCategory.pipe:
            print("pipe!")
            if gameState == .playing {
                gameOver()
            }
        case PhysicsCategory.score:
            score += 1
            self.run(SoundFX.point)
            print(score)
        default:
            break
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let rotation = self.bird.zRotation
        if rotation > 0 {
            self.bird.zRotation = min(rotation, 0.7)
        } else {
            self.bird.zRotation = max(rotation, -0.7)
        }
        
        if self.gameState == .dead {
            self.bird.physicsBody?.velocity.dx = 0
        }
    }
    
    func gameOver() {
        damageEffect()
        cameraShake()
        
        self.bird.removeAllActions()
        createGameoverBoard()
        
        self.bgmPlayer.run(SKAction.stop())
        
        self.gameState = .dead

    }
    
    func recordBestScore() {
        let userDefaults = UserDefaults.standard
        var bestScore = userDefaults.integer(forKey: "bestScore")
        
        if self.score > bestScore {
            bestScore = self.score
            userDefaults.set(bestScore, forKey: "bestScore")
        }
        userDefaults.synchronize()
    }
    
    func createGameoverBoard() {
        recordBestScore()
        
        let gameoverBoard = SKSpriteNode(imageNamed: "gameoverBoard")
        gameoverBoard.position = CGPoint(x: self.size.width / 2,
                                         y: -gameoverBoard.size.height)
        gameoverBoard.zPosition = Layer.hud
        addChild(gameoverBoard)
        
        var medal = SKSpriteNode()
        if score >= 10 {
            medal = SKSpriteNode(imageNamed: "medalPlatinum")
        } else if score >= 5 {
            medal = SKSpriteNode(imageNamed: "medalGold")
        } else if score >= 3 {
            medal = SKSpriteNode(imageNamed: "medalSilver")
        } else if score >= 1 {
            medal = SKSpriteNode(imageNamed: "medalBronze")
        }
        medal.position = CGPoint(x: -gameoverBoard.size.width * 0.27,
                                 y: gameoverBoard.size.height * 0.02)
        medal.zPosition = 0.1
        gameoverBoard.addChild(medal)
        
        let scoreLabel = SKLabelNode(fontNamed: "Minercraftory")
        scoreLabel.fontSize = 13
        scoreLabel.fontColor = .orange
        scoreLabel.text = "\(self.score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: gameoverBoard.size.width * 0.35,
                                      y: gameoverBoard.size.height * 0.07)
        scoreLabel.zPosition = 0.1
        gameoverBoard.addChild(scoreLabel)
        
        let bestScore = UserDefaults.standard.integer(forKey: "bestScore")
        let bestScoreLabel = SKLabelNode(fontNamed: "Minercraftory")
        bestScoreLabel.fontSize = 13
        bestScoreLabel.fontColor = .orange
        bestScoreLabel.text = "\(bestScore)"
        bestScoreLabel.horizontalAlignmentMode = .left
        bestScoreLabel.position = CGPoint(x: gameoverBoard.size.width * 0.35,
                                          y: -gameoverBoard.size.height * 0.07)
        bestScoreLabel.zPosition = 0.1
        gameoverBoard.addChild(bestScoreLabel)
        
        let restartBtn = SKSpriteNode(imageNamed: "playBtn")
        restartBtn.name = "restartBtn"
        restartBtn.position = CGPoint(x: 0, y: -gameoverBoard.size.height * 0.35)
        restartBtn.zPosition = 0.1
        gameoverBoard.addChild(restartBtn)
        
        gameoverBoard.run(SKAction.sequence([SKAction.moveTo(y: self.size.height / 2, duration: 1),
                                             SKAction.run { self.speed = 0 }]))
    }
    
    func damageEffect() {
        let flashNode = SKSpriteNode(color: UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
                                     size: self.size)
        let actionSequence = SKAction.sequence([SKAction.wait(forDuration: 0.01),
                                                SKAction.removeFromParent()])
        flashNode.name = "flashNode"
        flashNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        flashNode.zPosition = Layer.hud
        addChild(flashNode)
        flashNode.run(actionSequence)
        
        let wait = SKAction.wait(forDuration: 1)
        let soundSequence = SKAction.sequence([SoundFX.hit, wait, SoundFX.die])
        run(soundSequence)
    }
    
    func cameraShake() {
        let moveLeft = SKAction.moveTo(x: self.size.width / 2 - 5, duration: 0.1)
        let moveRight = SKAction.moveTo(x: self.size.width / 2 + 5, duration: 0.1)
        let moveReset = SKAction.moveTo(x: self.size.width / 2, duration: 0.1)
        let shakeAction = SKAction.sequence([moveLeft, moveRight, moveLeft, moveRight, moveReset])
        shakeAction.timingMode = .easeInEaseOut
        self.cameraNode.run(shakeAction)
    }
    
    func createRain() {
        guard let rainField = SKEmitterNode(fileNamed: "rain") else { return }
        rainField.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        rainField.zPosition = Layer.rain
        rainField.advanceSimulationTime(30)
        addChild(rainField)
    }
}
