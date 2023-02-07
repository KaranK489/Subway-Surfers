//
//  ContentView.swift
//  Space Invaders
//
//  Created by Conant Cougars on 1/13/22.
//

import SwiftUI
import SpriteKit
import GameKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let background = SKSpriteNode(imageNamed: "road-NEW-2X")
  
    
    var player = SKSpriteNode()
    var switchPlayerPicTimer = Timer()
    var switchPlayerTimerInterval = 0.4
    var imageNum = 1
    var playerHorzPos = 2
//    var playerFire = SKSpriteNode()
    
    var enemy = SKSpriteNode()
    var enemyTimer = Timer()
    var enemyMoveAcrossScreenDuration = 3.0


    var collisionTimer = Timer()
    
    var score = 0
    var scoreDisplay = SKLabelNode(fontNamed: "Arial-BoldMT")
    
    var pauseBtn = SKSpriteNode(imageNamed: "pause")
    var playBtn = SKSpriteNode(imageNamed: "play")
    


    var testTimer = Timer()
    
    
    
    
    struct CBitmask {
        static let playerPhys: UInt32 = 0b1
        static let enemyPhys: UInt32 = 0b100
        
    }
    
    //COLLISION:
    //https://www.youtube.com/watch?v=n7rzmYc5TWI
    //https://www.youtube.com/watch?v=mv-s6iUugIE
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 750, height: 1335)
        
        
        
        background.position = CGPoint(x: (size.width / 2)-5, y: size.height / 2)
        background.setScale(2.4)
//        background.zPosition = 1
        addChild(background)
        
//        let moveAction = SKAction.moveTo(y: 0, duration: TimeInterval(5))
//        background.run(moveAction)
        
        //        print(background.position.y)
        //        print("SDFSF")
        
        
        
        //move background right to left; replace
//          var shiftBackground = SKAction.moveByX(-background.size().width, y: 0, duration: 9)
//          var replaceBackground = SKAction.moveByX(background.size().width, y:0, duration: 0)
//          var movingAndReplacingBackground = SKAction.repeatActionForever(SKAction.sequence([shiftBackground,replaceBackground]))
//
//            for i in 0..<3 {
//              //defining background; giving it height and moving width
//              background=SKSpriteNode(texture:backgroundTexture)
//              background.position = CGPoint(x: backgroundTexture.size().width/2 + (backgroundTexture.size().width * i), y: CGRectGetMidY(self.frame))
//              background.size.height = self.frame.height
//              background.runAction(movingAndReplacingBackground)
//
//              self.addChild(background)
//          }
//
        
        pauseBtn.position = CGPoint(x: 676, y: 1222)
        pauseBtn.xScale = 0.3
        pauseBtn.yScale = 0.25
        pauseBtn.zPosition = 15
        pauseBtn.name = "pauseBtn"
        addChild(pauseBtn)
        
        
        
        playBtn.position = CGPoint(x: 676, y: 1222)
        playBtn.xScale = 0.3
        playBtn.yScale = 0.25
        playBtn.zPosition = 15
        playBtn.name = "playBtn"
       
        
        
        
        
        
        
        
       
        scoreDisplay.text = "Score: 0"
        scoreDisplay.position = CGPoint(x: 118, y: 1236)
        addChild(scoreDisplay)
        

        makePlayer()
        

        
        enemyTimer = .scheduledTimer(timeInterval: 1.4, target: self, selector: #selector(makeEnemys), userInfo: nil, repeats: true)
        
//        collisionTimer = .scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(checkCollisions), userInfo: nil, repeats: true)
        
        
        activateSwitchPlayerTimer()
        

        
//        testTimer =  .scheduledTimer(timeInterval: 5.1, target: self, selector: #selector(tester), userInfo: nil, repeats: true)
        
        
        //swiping control
        let swipeRight = UISwipeGestureRecognizer(target: self,
              action: #selector(GameScene.swipeRight(sender:)))
          swipeRight.direction = .right
          view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self,
            action: #selector(GameScene.swipeLeft(sender:)))
            swipeLeft.direction = .left
          view.addGestureRecognizer(swipeLeft)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA : SKPhysicsBody
        let contactB : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contactA = contact.bodyA
            contactB = contact.bodyB
        } else {
            contactA = contact.bodyB
            contactB = contact.bodyA
        }
        
        
        if contactA.categoryBitMask == CBitmask.playerPhys && contactB.categoryBitMask == CBitmask.enemyPhys {
            (contactB.node as! SKSpriteNode).removeFromParent()
            player.removeFromParent()
            

        }
    }
    
    
    override func update(_ currentTime: TimeInterval){
        
    }
    
    
    @objc func tester(){
//        print("test")
//
//
//        background.position.y = 667
//
////        let moveAction = SKAction.moveTo(y: 0, duration: TimeInterval(5))
//
//        let moveAction = SKAction.moveTo(y: background.position.y - 667, duration: TimeInterval(5))
//
//
//        background.run(moveAction)
//
//
//        print(background.position.y)
//
        
    }
    
    
    
//    func createGround() {
//
//        for i in 0..<2{
//
//            let ground = SKSpriteNode(imageNamed: "road-NEW-2X")
//            ground.name = "ground"
//            ground.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!/7)
//            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            ground.position = CGPoint(x: CGFloat(i)*ground.size.width, y: -self.frame.size.height / 2)
//
//            addChild(ground)
//        }
//    }
    
    
    
//
//    func moveGround() {
//        self.enumerateChildNodes(withName: "ground") {  (node, error) in
//            node.position.x -= 5
//
//            if node.position.x < -(self.scene?.size.width)! {
//
//                node.position.x += ((self.scene?.size.width)!) * 2
//            }
//        }
//    }

    
    
    
    func activateSwitchPlayerTimer(){
        switchPlayerPicTimer = .scheduledTimer(timeInterval: TimeInterval(switchPlayerTimerInterval), target: self, selector: #selector(switchPlayerPic), userInfo: nil, repeats: true)
    }
    
    //figure out how to make it change faster overtime
    @objc func switchPlayerPic() {
        score = score + 1
        scoreDisplay.removeFromParent()
        scoreDisplay.text = "Score: " + String(score)
        addChild(scoreDisplay)
        
        
        if imageNum == 1 {
            player.texture = SKTexture(imageNamed: "runner-2")
            imageNum = 2
        } else if imageNum == 2 {
            player.texture = SKTexture(imageNamed: "runner-1")
            imageNum = 3
        } else if imageNum == 3 {
            player.texture = SKTexture(imageNamed: "runner-0")
            imageNum = 4
        } else if imageNum == 4{
            player.texture = SKTexture(imageNamed: "runner-4")
            imageNum = 5
        } else if imageNum == 5{
            player.texture = SKTexture(imageNamed: "runner-3")
            imageNum = 6
        } else {
            player.texture = SKTexture(imageNamed: "runner-0")
            imageNum = 1
            switchPlayerPicTimer.invalidate()
            
            
            if switchPlayerTimerInterval>0.1{
                switchPlayerTimerInterval = switchPlayerTimerInterval*0.98
            }
//            print(switchPlayerTimerInterval)
            activateSwitchPlayerTimer()
        }
      

    }
    
    
    
    
    //375
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
//        self.scene?.view?.isPaused = true
        var newXPos = 0
        
        if playerHorzPos == 1 {
            newXPos = 375
            playerHorzPos = 2
        } else if playerHorzPos == 2 {
            newXPos = 640
            playerHorzPos = 3
        } else {
            newXPos = 640
        }
        
        let moveAction = SKAction.moveTo(x: CGFloat(newXPos), duration: 0.15)
        
        player.run(moveAction)
        
        
    }
    
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
//        self.scene?.view?.isPaused = false
        var newXPos = 0
        
        if playerHorzPos == 1 {
            newXPos = 110
        } else if playerHorzPos == 2 {
            newXPos = 110
            playerHorzPos = 1
        } else {
            playerHorzPos = 2
            newXPos = 375
        }
        
        let moveAction = SKAction.moveTo(x: CGFloat(newXPos), duration: 0.15)
        
        player.run(moveAction)
    }
    
    
   
    
    
    func makePlayer(){

        
        player.name = "player"
        player = .init(imageNamed: "runner-0")
        player.position = CGPoint(x: size.width/2, y: 420)
        player.zPosition = 10
        player.setScale(2)
        
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerPhys
        player.physicsBody?.contactTestBitMask = CBitmask.enemyPhys
        player.physicsBody?.collisionBitMask = CBitmask.enemyPhys
        
       
        addChild(player)
//        var textureArray = [SKTexture]()
//        textureArray.append(SKTexture(imageNamed: "runner-0"))
//        textureArray.append(SKTexture(imageNamed: "runner-1"))
//        textureArray.append(SKTexture(imageNamed: "runner-2"))
//
//        var anim = SKAction.animate(with: textureArray, timePerFrame: TESTtime)
//        let forever = SKAction.repeatForever(anim)
//        player.run(forever)
        
        
//        let testing = SKAction.animate(withNormalTextures: [SKTexture(imageNamed: "runner-0"), SKTexture(imageNamed: "runner-1")], timePerFrame: 0.1)
        
        
   
        
    }
    
    @objc func checkCollisions(){
        
        
        
        
        
//        enumerateChildNodes(withName: "enemy") {node, _ in
//            let enemy = node as! SKSpriteNode
//            if self.player.frame.intersects(self.enemy.frame) {
                

//
//                hitEnemy.append(self.enemy)
//                    print("intersecting")

//                self.player.removeFromParent()
//                print("game over")
//                self.enemyMoveAcrossScreenDuration = 0
//                for enemyLoop in hitEnemy{
//                    if self.enemy == enemyLoop{   //check to see if its same enemy, to prevent looping
//                        run = false
//                        print("SAME")
//                    }
//                }
                
                
//                if run{
//                    hitEnemy.append(self.enemy)
//                    self.score = self.score-1
//                    print("SCORE: " + String(self.score))
//                }
                
//            }
//        }
        
//        for enemy in hitEnemy {
//            print(enemy)
//        }

    }
    

    		
    @objc func makeEnemys(){
        enemyMoveAcrossScreenDuration = enemyMoveAcrossScreenDuration * 0.99
        
    

        let positionRandNum = Int.random(in: 0..<3)
        let picRandom = Int.random(in: 0..<2)

    
        
        if (picRandom == 0){
            enemy = .init(imageNamed: "red-car")
            enemy.setScale(0.45)
        } else {
            enemy = .init(imageNamed: "yellow-car")
            enemy.setScale(0.15)
        }
        
        //1170
        if (positionRandNum==0){
            enemy.position = CGPoint(x: 100, y: 1400)
//            print("ONE")
        } else if (positionRandNum==1){
            enemy.position = CGPoint(x: 360, y: 1400)
//            print("TWO")
        } else {
            enemy.position = CGPoint(x: 620, y: 1400)
//            print("THREE")
        }
//        enemy = .init(imageNamed: "enemy-ship")
        enemy.name = "enemy"
//        enemy.position = CGPoint(x: randomNumber.nextInt(), y: 1400)
        enemy.zPosition = 5
//        enemy.setScale(0.5)
        
        
        
        
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
    
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyPhys
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerPhys
        enemy.physicsBody?.collisionBitMask = CBitmask.playerPhys
        
        
        
        
        
        
        
        
        addChild(enemy)
        
        
        //change duration variable to change speed of cars
        let moveAction = SKAction.moveTo(y: -100, duration: TimeInterval(enemyMoveAcrossScreenDuration))
        let delateAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, delateAction])
        
        enemy.run(combine)
    }
    
    
    
    
    

//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let location = touch.location(in: self)
//
//            player.position.x = location.x
////            makeEnemys()
//        }
//
//    }
    
    

   
    //648-726 x
    //1195-1260 y
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let location = touch.location(in: self)
        
        if (location.x<732 && location.x>623 && location.y>1173 && location.y<1260){
            var oldState = (self.scene?.view?.isPaused)!
            print(oldState)


            if (oldState){
                addChild(pauseBtn)
                
                playBtn.removeFromParent()
            } else {
                addChild(playBtn)
                pauseBtn.removeFromParent()
               
            }

            var a = Timer()
            a = .scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(pauseScene), userInfo: nil, repeats: false)
          
        }
        
        
        
    }
    
    //ADD HERE: PAUSE TIMERS AND EVERYTHING ELSE SO GAME FULLY STOPS!!!!!!!!!!!!!!!!!!!!!
    @objc func pauseScene  (){
        self.scene?.view?.isPaused = !(self.scene?.view?.isPaused)!
    }
    
}

struct ContentView: View {
    let scene = GameScene()
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
