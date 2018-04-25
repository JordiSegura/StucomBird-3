//
//  GameScene.swift
//  StucomBird
//
//  Created by DAM on 10/4/18.
//  Copyright © 2018 DAM. All rights reserved.
//

import SpriteKit
import GameplayKit
//https://ryanlinnane.github.io/spritekit-skcameranode/
//https://medium.com/@kkostov/til-how-to-use-skcameranode-in-spritekit-games-1b025ff4a4bd
//https://stackoverflow.com/questions/33218771/spawn-balls-random-position-out-of-the-screen
// Necesario para tratar con colisiones SKPhysicsContactDelegate
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
        
        createEnemies()
        
    }
    
    deinit{
        print("deinit called")
    }
    
    
    
    func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    //Helper method for spawning a point along the screen borders. This will not work for diagonal lines.
    func randomPointBetween(start:CGPoint, end:CGPoint)->CGPoint{
        
        return CGPoint(x: randomBetweenNumbers(firstNum: start.x, secondNum: end.x), y: randomBetweenNumbers(firstNum: start.y, secondNum: end.y))
        
    }
    
    
    func createEnemies(){
        
        //Randomize spawning time.
        //This will create a node every 0.5 +/- 0.1 seconds, means between 0.4 and 0.6 sec
        let wait = SKAction .wait(forDuration: 0.1, withRange: 0.2)
        
        
        weak var  weakSelf = self //Use weakSelf to break a possible strong reference cycle
        
        
        let spawn = SKAction.run({
            
            var random = arc4random() % 4 +  1
            var position = CGPoint()
            var moveTo = CGPoint()
            var offset:CGFloat = 40
            
            print(random)
            
            switch random {
                
            //Top
            case 1:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: weakSelf!.frame.height), end: CGPoint(x: weakSelf!.frame.width, y: weakSelf!.frame.height))
                
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: 0), end: CGPoint(x:weakSelf!.frame.width, y:0))
                
                break
                
            //Bottom
            case 2:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: 0), end: CGPoint(x: weakSelf!.frame.width, y: 0))
                
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: weakSelf!.frame.height), end: CGPoint(x: weakSelf!.frame.width, y: weakSelf!.frame.height))
                
                break
                
            //Left
            case 3:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: weakSelf!.frame.height))
                
                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: weakSelf!.frame.width, y: 0), end: CGPoint(x: weakSelf!.frame.width, y: weakSelf!.frame.height))
                
                break
                
            //Right
            case 4:
                position = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: weakSelf!.frame.height))

                //Move to opposite side
                moveTo = weakSelf!.randomPointBetween(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: weakSelf!.frame.height))
                break
                
            default:
                break
                
            }
            
            weakSelf!.spawnEnemyAtPosition(position: position, moveTo: moveTo)
            
        })
        
        let spawning = SKAction.sequence([wait,spawn])
        
        self.run(SKAction.repeatForever(spawning), withKey:"spawning")
        
        
    }
    
    
    func spawnEnemyAtPosition(position:CGPoint, moveTo:CGPoint){
        
        let enemy = SKSpriteNode(color: SKColor.brown, size: CGSize(width: 40, height: 40))
        
        
        enemy.position = position
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.collisionBitMask = 0 // no collisions
        //Here you can randomize the value of duration parameter to change the speed of a node
        let move = SKAction.move(to: moveTo,duration: 2.5)
        let remove = SKAction.removeFromParent()
        enemy.run(SKAction.sequence([move, remove]))
        
        
        self.addChild(enemy)
        
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
    }
    
    
    /*
     
     Added for debugging purposes
     
     override func touchesBegan(touches: NSSet, withEvent event: UIEvent?) {
     
     //Just make a transition to the other scene, in order to check if deinit is called
     //You have to make a new scene ... I named it WelcomeScene
     var scene:WelcomeScene = WelcomeScene(fileNamed: "WelcomeScene.sks")
     
     scene.scaleMode = .AspectFill
     
     self.view?.presentScene(scene )
     
     
     }
     */
    
}
