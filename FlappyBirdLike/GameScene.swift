//
//  GameScene.swift
//  FlappyBirdLike
//
//  Created by Kyunghun Jung on 22/05/2019.
//  Copyright © 2019 qualitybits.net. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        let bgColor = SKColor(red: 81.0 / 255.0, green: 192.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)
        self.backgroundColor = bgColor
        
        createBird()
        createEnvironment()
        setupPipe()
    }
    
    func createBird() {        
        let bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width / 2, y: 350)
        bird.zPosition = Layer.bird
        addChild(bird)
        
        guard let flyingBySKS = SKAction(named: "flying") else { return }
        bird.run(flyingBySKS)
    }
    
    func createEnvironment() {
        let envAtlas = SKTextureAtlas(named: "Environment")
        let landTexture = envAtlas.textureNamed("land")
        let landRepeatNum = Int(ceil(self.size.width / landTexture.size().width))
        let skyTexture = envAtlas.textureNamed("sky")
        let skyRepeatNum = Int(ceil(self.size.width / skyTexture.size().width))
        let ceilTexture = envAtlas.textureNamed("ceiling")
        let ceilRepearNum = Int(ceil(self.size.width / ceilTexture.size().width))
        
        for i in 0...landRepeatNum {
            let land = SKSpriteNode(texture: landTexture)
            land.anchorPoint = CGPoint.zero
            land.position = CGPoint(x: CGFloat(i) * land.size.width, y: 0)
            land.zPosition = Layer.land
            
            addChild(land)
            
            let moveLeft = SKAction.moveBy(x: -landTexture.size().width, y: 0, duration: 20)
            let moveReset = SKAction.moveBy(x: landTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            land.run(SKAction.repeatForever(moveSequence))
        }
        
        for i in 0...skyRepeatNum {
            let sky = SKSpriteNode(texture: skyTexture)
            sky.anchorPoint = CGPoint.zero
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: envAtlas.textureNamed("land").size().height)
            sky.zPosition = Layer.sky
            addChild(sky)
            
            let moveLeft = SKAction.moveBy(x: -skyTexture.size().width, y: 0, duration: 40)
            let moveReset = SKAction.moveBy(x: skyTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            sky.run(SKAction.repeatForever(moveSequence))
        }
        
        for i in 0...ceilRepearNum {
            let ceiling = SKSpriteNode(texture: ceilTexture)
            ceiling.anchorPoint = CGPoint.zero
            ceiling.position = CGPoint(x: CGFloat(i) * ceiling.size.width, y: self.size.height - ceiling.size.height / 2)
            ceiling.zPosition = Layer.ceiling
            addChild(ceiling)
            
            let moveLeft = SKAction.moveBy(x: -ceilTexture.size().width, y: 0, duration: 3)
            let moveReset = SKAction.moveBy(x: ceilTexture.size().width, y: 0, duration: 0)
            let moveSequence = SKAction.sequence([moveLeft, moveReset])
            ceiling.run(SKAction.repeatForever(moveSequence))
        }
    }
    
    func setupPipe() {
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x: self.size.width / 2, y: 0)
        pipeDown.zPosition = Layer.pipe
        self.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x: self.size.width / 2, y: self.size.height + 100)
        pipeUp.zPosition = Layer.pipe
        pipeUp.xScale = -1
        pipeUp.zRotation = .pi
        self.addChild(pipeUp)
    }
    
}
