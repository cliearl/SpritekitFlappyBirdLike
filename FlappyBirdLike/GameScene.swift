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
        createBird()
        createEnvironment()
        
    }
    
    func createBird() {
//        let birdArray = SKTextureAtlas(named: "Bird")
        
        let bird = SKSpriteNode(imageNamed: "bird1")
        bird.position = CGPoint(x: self.size.width / 2, y: 350)
        bird.zPosition = 4
        self.addChild(bird)
        
        // 애니메이션 파트
//        var aniArray = [SKTexture]()
//        for i in 1...birdArray.textureNames.count {
//            aniArray.append(SKTexture(imageNamed: "bird\(i)"))
//        }
//        let flyingAnimation = SKAction.animate(with: aniArray, timePerFrame: 0.1)
//        bird.run(SKAction.repeatForever(flyingAnimation))
        
        guard let flyingBySKS = SKAction(named: "flying") else { return }
        bird.run(flyingBySKS)
    }
    
    func createEnvironment() {
        let land = SKSpriteNode(imageNamed: "land")
        land.position = CGPoint(x: self.size.width / 2, y: 50)
        land.zPosition = 3
        self.addChild(land)
        print(self.size.width / land.size.width)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x: self.size.width / 2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.position = CGPoint(x: self.size.width / 2, y: self.size.height)
        ceiling.zPosition = 3
        self.addChild(ceiling)
        
        let pipeDown = SKSpriteNode(imageNamed: "pipe")
        pipeDown.position = CGPoint(x: self.size.width / 2, y: 0)
        pipeDown.zPosition = 2
        self.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(imageNamed: "pipe")
        pipeUp.position = CGPoint(x: self.size.width / 2, y: self.size.height + 100)
        pipeUp.zPosition = 2
        pipeUp.xScale = -1
        pipeUp.zRotation = .pi
        self.addChild(pipeUp)
    }
    
}
