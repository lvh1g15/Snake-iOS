//
//  GameScene.swift
//  SnakeWithSprite
//
//  Created by Landon Vago-Hughes on 10/09/2017.
//  Copyright © 2017 Landon Vago-Hughes. All rights reserved.

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var randomApple: SKShapeNode?
    private var randomDisY = GKRandomDistribution(lowestValue: -600, highestValue: 600)
    private var randomDisX = GKRandomDistribution(lowestValue: -300, highestValue: 300)
    private var positionArrayX = [CGFloat]()
    private var positionArrayY = [CGFloat]()
    private var lastSwipe = ""
    
    override func didMove(to view: SKView) {

        let w = (self.size.width + self.size.height) * 0.02
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w))

        self.physicsWorld.contactDelegate = self
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.fillColor = UIColor.red
            spinnyNode.lineWidth = 2.5
            spinnyNode.strokeColor = UIColor.red
            spinnyNode.name = "Snake"
            spinnyNode.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width + self.size.height) * 0.005)
            spinnyNode.physicsBody?.affectedByGravity = false
            spinnyNode.physicsBody?.usesPreciseCollisionDetection = true
            spinnyNode.physicsBody?.contactTestBitMask = UInt32.init(0x10101001)
        }

        let swipeDownGesture: [UISwipeGestureRecognizerDirection] = [.down, .up, .right, .left]
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(up(sender:)))
        let gesture2 = UISwipeGestureRecognizer(target: self, action: #selector(down(sender:)))
        let gesture3 = UISwipeGestureRecognizer(target: self, action: #selector(right(sender:)))
        let gesture4 = UISwipeGestureRecognizer(target: self, action: #selector(left(sender:)))

        gesture.direction = swipeDownGesture[1]
        gesture2.direction = swipeDownGesture[0]
        gesture3.direction = swipeDownGesture[2]
        gesture4.direction = swipeDownGesture[3]

        view.addGestureRecognizer(gesture)
        view.addGestureRecognizer(gesture2)
        view.addGestureRecognizer(gesture3)
        view.addGestureRecognizer(gesture4)

    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyB.node?.name! == "apple" && contact.bodyA.node?.name! == "Snake" {
            contact.bodyB.node?.removeFromParent()
            randomAppleGenerate()
            appendAnotherCube()
        }
    }
    
    func appendAnotherCube() {
        if let p = self.spinnyNode?.copy() as! SKShapeNode? {
            self.addChild(p)
            
            let countArray = positionArrayX.count
            p.position.x = positionArrayX[countArray-1]
            p.position.y = positionArrayY[countArray-1]
            positionArrayX.append(p.position.x)
            positionArrayY.append(p.position.y)
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if self.children.count > 0 {
            return
        } else {
            if let n = self.spinnyNode?.copy() as! SKShapeNode? {
                n.position = pos
                self.addChild(n)
                let moveNodeUp = SKAction.moveBy(x: 0.0,
                                                 y: self.size.height/2 - pos.y, duration: 2)
                moveNodeUp.speed = 0.6
                n.run(moveNodeUp)
                positionArrayX.append(n.position.x)
                positionArrayY.append(n.position.y)
            }
            randomAppleGenerate()
        }
    }
    
    func randomAppleGenerate() {
        let k = (self.size.width + self.size.height) * 0.01
        self.randomApple = SKShapeNode.init(rectOf: CGSize(width: k, height: k), cornerRadius: 10)
        
        if let randomApple = self.randomApple {
            randomApple.fillColor = UIColor.green
            randomApple.name = "apple"
            randomApple.physicsBody = SKPhysicsBody(circleOfRadius: (self.size.width + self.size.height) * 0.005)
            randomApple.physicsBody?.affectedByGravity = false
            randomApple.physicsBody?.usesPreciseCollisionDetection = true
            randomApple.physicsBody?.categoryBitMask = UInt32.init(0x10101001)
        }

        if let p = self.randomApple?.copy() as! SKShapeNode? {
            p.position = CGPoint(x: randomDisX.nextInt(), y: randomDisY.nextInt())
            self.addChild(p)
        }
    }
    
    @objc private func down(sender: UISwipeGestureRecognizer) {
        if self.lastSwipe == "down" || self.lastSwipe == "up" {
            return
        }
        self.lastSwipe = "down"
        let secondView = self.children[0]
            secondView.removeAllActions()
            let moveNodeRight = SKAction.moveBy(x: 0, y: -(self.size.height/2 - secondView.position.y), duration: 2)
            moveNodeRight.speed = 0.6
            secondView.run(moveNodeRight)
    }
    
    @objc private func up(sender: UISwipeGestureRecognizer) {
        if self.lastSwipe == "down" || self.lastSwipe == "up" {
            return
        }
        self.lastSwipe = "up"
        let secondView = self.children[0]
            secondView.removeAllActions()
            let moveNodeRight = SKAction.moveBy(x: 0, y: self.size.height/2 - secondView.position.y, duration: 2)
            moveNodeRight.speed = 0.6
            secondView.run(moveNodeRight)
    }
    
    @objc private func right(sender: UISwipeGestureRecognizer) {
        if self.lastSwipe == "right" || self.lastSwipe == "left" {
            return
        }
        self.lastSwipe = "right"
        let secondView = self.children[0]
            secondView.removeAllActions()
            let moveNodeRight = SKAction.moveBy(x: self.size.height/2 - secondView.position.x, y: 0, duration: 2)
            moveNodeRight.speed = 0.6
            secondView.run(moveNodeRight)
    }
    
    @objc private func left(sender: UISwipeGestureRecognizer) {
        if self.lastSwipe == "right" || self.lastSwipe == "left" {
            return
        }
        self.lastSwipe = "left"
        let secondView = self.children[0]
            secondView.removeAllActions()
            let moveNodeRight = SKAction.moveBy(x: -(self.size.height/2 - secondView.position.x), y: 0, duration: 2)
            moveNodeRight.speed = 0.6
            secondView.run(moveNodeRight)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    func sorrr(arr: [CGFloat], insertt: CGFloat) -> [CGFloat] {
        var finalArray = [CGFloat]()
        var d = arr
        var a = 0
        var b = 0
        for i in 0..<d.count+1 {
            if i == d.count-1 {
                d[0] = insertt
                finalArray = d
                return finalArray
            } else {
                if i == 0 {
                    a = Int(d[i+1])
                    d[i+1] = d[i]
                } else {
                    b = Int(d[i+1])
                    d[i+1] = CGFloat(a)
                    a = b
                }
            }
        }
        return finalArray
    }

    override func update(_ currentTime: TimeInterval) {
        
        if currentTime.truncatingRemainder(dividingBy: 10) == 0 {
            if positionArrayY.count == 0 {
                
            } else {
                
                let numberOfNodes = self.children.count
                let firstCubePosX = self.children[0].position.x
                let firstCubePosY = self.children[0].position.y
                
                let newPosishX = sorrr(arr: positionArrayX, insertt: firstCubePosX)
                let newPosisY = sorrr(arr: positionArrayY, insertt: firstCubePosY)
                
                if numberOfNodes > 2 {
                    for i in 1..<numberOfNodes {
                        self.children[i].position.x = newPosishX[i-1]
                        self.children[i].position.y = newPosisY[i-1]
                    }
                }
            }
        }
    }
}
