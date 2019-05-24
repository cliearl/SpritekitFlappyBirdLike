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
        let land = SKSpriteNode(imageNamed: "land")
        land.position = CGPoint(x: self.size.width / 2, y: 50)
        land.zPosition = 3
        self.addChild(land)
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPoint(x: self.size.width / 2, y: 100)
        sky.zPosition = 1
        self.addChild(sky)
        
        let bird = SKSpriteNode(imageNamed: "bird")
        bird.position = CGPoint(x: self.size.width / 2, y: 350)
        bird.zPosition = 4
        self.addChild(bird)
        
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
