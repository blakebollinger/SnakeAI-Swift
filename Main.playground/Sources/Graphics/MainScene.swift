//
//  MainScene.swift
//  Snake-AI
//

/*

 Handles:
 Initialization of graphics
 Inversion of graphics colors as the buttons are clicked
 Movement of graphics
 
*/

import PlaygroundSupport
import SpriteKit
import UIKit

/// Constants of the game
let screenHeight = 768.0
let screenWidth = 1024.0

public class MainScene: SKScene {
    
    // MARK: Initializations
    
    // Initializes the variables for the SKScene
    private var title : SKSpriteNode!
    public static var score : SKLabelNode!
    private var scoreLabel : SKSpriteNode!
    private var highScoreLabel : SKSpriteNode!
    public static var highScore : SKLabelNode!
    public static var highScoreInt: Int = 0
    private var arrows : SKSpriteNode!
    private var spinnyNode : SKShapeNode!
    private var rectangle : SKShapeNode!
    private var grid : SKSpriteNode!
    private var faster : SKSpriteNode!
    private var slower : SKSpriteNode!
    private var neuralNet : SKSpriteNode!
    private var neuralNetOn : SKSpriteNode!
    private var neuralNetOff : SKSpriteNode!
    private static var head : SKShapeNode!
    private var body : SKShapeNode!
    public static var bodySegments: Array<SKShapeNode> = []
    private static var moveDuration: Double!
    private static var food: SKShapeNode!
    var foodPosition = Food()
    public static var foods: Array<SKShapeNode> = []
    let fadeIn = SKAction.sequence([.fadeIn(withDuration: 2.0)])
    
    
    public override func didMove(to view: SKView) {
        
        MainScene.moveDuration = Game.interval/4
        
        // Title
        title = SKSpriteNode(imageNamed: "Title.png")
        title.alpha = 0.0
        title.xScale = 0.66
        title.yScale = 0.66
        title.position = CGPoint(x: 0, y: 330)
        addChild(title)
        title.run(SKAction.fadeIn(withDuration: 2))

        // Updating score number
        MainScene.score = childNode(withName: "//score") as? SKLabelNode
        MainScene.score.alpha = 0.0
        MainScene.score.fontSize = 27
        MainScene.score.fontName = "AmericanTypewriter-Bold"
        MainScene.score.text = "\(Snake.score)"
        MainScene.score.position = CGPoint(x: 290.5, y: 224)
        MainScene.score.run(fadeIn)

        // Score label
        scoreLabel = SKSpriteNode(imageNamed: "Score.png")
        scoreLabel.alpha = 0.0
        scoreLabel.position = CGPoint(x: 230, y: 226)
        addChild(scoreLabel)
        scoreLabel.run(SKAction.fadeIn(withDuration: 2))
        
        // High Score label
        highScoreLabel = SKSpriteNode(imageNamed: "HighScore.png")
        highScoreLabel.alpha = 0.0
        highScoreLabel.position = CGPoint(x: 396, y: 226)
        addChild(highScoreLabel)
        highScoreLabel.run(SKAction.fadeIn(withDuration: 2))
        
        // Updating high score number
        MainScene.highScore = childNode(withName: "//highScore") as? SKLabelNode
        MainScene.highScore.alpha = 0.0
        MainScene.highScore.fontSize = 27
        MainScene.highScore.fontName = "AmericanTypewriter-Bold"
        MainScene.highScore.text = "\(Snake.score)"
        MainScene.highScoreInt = 0
        MainScene.highScore.position = CGPoint(x: 456, y: 209)
        MainScene.highScore.run(fadeIn)
        
        // Game Arrows
        arrows = SKSpriteNode(imageNamed: "Arrows.png")
        arrows.alpha = 0.0
        arrows.position = CGPoint(x: 330, y: -65)
        addChild(arrows)
        arrows.run(SKAction.fadeIn(withDuration: 2))
        
        // Grid
        grid = SKSpriteNode(imageNamed: "Grid.png")
        grid.alpha = 0.0
        grid.position = CGPoint(x: -152, y: -24)
        addChild(grid)
        grid.run(SKAction.fadeIn(withDuration: 2))
        
        // Faster Button
        faster = SKSpriteNode(imageNamed: "Fast.png")
        faster.alpha = 0.0
        faster.position = CGPoint(x: 409, y: 126)
        addChild(faster)
        faster.run(SKAction.fadeIn(withDuration: 2))
        
        // Slower Button
        slower = SKSpriteNode(imageNamed: "Slow.png")
        slower.alpha = 0.0
        slower.position = CGPoint(x: 248, y: 126)
        addChild(slower)
        slower.run(SKAction.fadeIn(withDuration: 2))
        
        // Neural Net Label
        neuralNet = SKSpriteNode(imageNamed: "ComputerControl.png")
        neuralNet.alpha = 0.0
        neuralNet.position = CGPoint(x: 238, y: -240.5)
        addChild(neuralNet)
        neuralNet.run(SKAction.fadeIn(withDuration: 2))
        
        // Neural Net on Button
        neuralNetOn = SKSpriteNode(imageNamed: "OnInvert.png")
        neuralNetOn.alpha = 0.0
        neuralNetOn.position = CGPoint(x: 362, y: -240.5)
        addChild(neuralNetOn)
        neuralNetOn.run(SKAction.fadeIn(withDuration: 2))
        
        // Neural Net off Button
        neuralNetOff = SKSpriteNode(imageNamed: "Off.png")
        neuralNetOff.alpha = 0.0
        neuralNetOff.position = CGPoint(x: 447, y: -240.5)
        addChild(neuralNetOff)
        neuralNetOff.run(SKAction.fadeIn(withDuration: 2))
        
        // Border Rectangle
        rectangle = SKShapeNode(rectOf: CGSize(width: screenWidth-5, height: screenHeight-5))
        self.addChild(rectangle)
        
        // Snake
        /// Head
        MainScene.head = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        MainScene.head.position = CGPoint(x: (MainScene.convertToBoardX(coordinate: Snake.position[0])), y: (MainScene.convertToBoardY(coordinate: Snake.position[0])))
        MainScene.head.alpha = 0.0
        self.addChild(MainScene.head)
        MainScene.head.run(fadeIn)
        /// Body
        for i in 1...2 {
            let body = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
            body.fillColor = SKColor.white
            body.alpha = 0.0
            body.position = CGPoint(x: (MainScene.convertToBoardX(coordinate: Snake.position[i])), y: (MainScene.convertToBoardY(coordinate: Snake.position[i])))
            MainScene.bodySegments.append(body)
            self.addChild(body)
            body.run(fadeIn)
        }
        
        // Food
        MainScene.food = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        MainScene.food.position = CGPoint(x: (-436.5)+Double((Food.x*30)), y: (-309)+Double((Food.y*30)))
        MainScene.food.alpha = 0.0
        MainScene.foods.append(MainScene.food)
        self.addChild(MainScene.food)
        MainScene.food.run(fadeIn)
        
    }
    
    // MARK: Functions
    
    // Update score text
    public static func updateScore() {
        
        /// Updates the text of the labelNode
        MainScene.score.text = "\(Snake.score)"
        
    }
    
    // Convert game "Board" x coordinates to screen coodinates
    static func convertToBoardX(coordinate: Coordinate) -> Double {
        
        /// Does math and returns
        return (-436.5)+Double((coordinate.x*30))
        
    }
    
    // Convert game "Board" y coordinates to screen coodinates
    static func convertToBoardY(coordinate: Coordinate) -> Double {
        
        /// Does math and returns
        return (-309)+Double((coordinate.y*30))
        
    }
    
    @objc static public override var supportsSecureCoding: Bool {
        get {
            return true
        }
    }
    
    /*
     When the screen is touched, this function:
     1. Determines where
     2. Preforms the action
     3. Sets the button to the "clicked-in" form if needed
    */
    func touchDown(atPoint pos : CGPoint) {
        /// Up arrow
        if pos.y > -60 && pos.y < 0 && pos.x > 300 && pos.x < 360 && Snake.direction != 2{
            Snake.direction = 0
            arrows.texture = SKTexture(imageNamed: "UpInvert.png")
        /// Right arrow
        } else if pos.x > 370 && pos.x < 440 && pos.y > -130 && pos.y < -70 && Snake.direction != 3{
            Snake.direction = 1
            arrows.texture = SKTexture(imageNamed: "RightInvert.png")
        /// Down arrow
        } else if pos.x > 300 && pos.x < 360 && pos.y > -130 && pos.y < -70 && Snake.direction != 0{
            Snake.direction = 2
            arrows.texture = SKTexture(imageNamed: "DownInvert.png")
        /// Left arrow
        } else if pos.x > 230 && pos.x < 290 && pos.y > -130 && pos.y < -70 && Snake.direction != 1{
            Snake.direction = 3
            arrows.texture = SKTexture(imageNamed: "LeftInvert.png")
        /// Slower button
        } else if pos.x > 190 && pos.x < 308 && pos.y > 73 && pos.y < 173 {
            Game.decreaseSpeed()
            slower.texture = SKTexture(imageNamed: "SlowInvert.png")
        // Faster button
        } else if pos.x > 348 && pos.x < 472 && pos.y > 73 && pos.y < 173 {
            Game.increaseSpeed()
            faster.texture = SKTexture(imageNamed: "FastInvert.png")
        // Neural net on button
        } else if pos.x > 331 && pos.x < 393 && pos.y < -212 && pos.y > -273 {
            neuralNetOn.texture = SKTexture(imageNamed: "OnInvert.png")
            neuralNetOff.texture = SKTexture(imageNamed: "Off.png")
            Game.neuralNet = true
        /// Neural Net off button
        } else if pos.x > 423 && pos.x < 479 && pos.y < -211 && pos.y > -271 {
            neuralNetOff.texture = SKTexture(imageNamed: "OffInvert.png")
            neuralNetOn.texture = SKTexture(imageNamed: "On.png")
            Game.neuralNet = false
        }
        
    }
    
    // Basic SpriteKit touches began
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchDown(atPoint: t.location(in: self)) }
    }
    
    // Basic SpriteKit touches ended
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    // Basic SpriteKit touches cancelled
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchUp(atPoint: t.location(in: self)) }
    }
    
    // Resets the buttons to their normal form when the touch is released
    func touchUp(atPoint pos : CGPoint) {
        
        slower.texture = SKTexture(imageNamed: "Slow.png")
        faster.texture = SKTexture(imageNamed: "Fast.png")
        arrows.texture = SKTexture(imageNamed: "Arrows.png")
        
    }
    
    // Handles graphics changes when a game ends
    public static func endGame() {
        
        /// Moves the food
        MainScene.moveFood()
        
        /// If there is a high score, display it
        if Snake.score > MainScene.highScoreInt {
            MainScene.highScore.text = "\(Snake.score)"
            MainScene.highScoreInt = Snake.score
        }
        
        /// Reset the score
        MainScene.score.text = "0"
        
        /// Remove the body segments from the screen
        for i in 2..<MainScene.bodySegments.count {
            MainScene.bodySegments[i].removeFromParent()
        }
        
        /// Remove the body segments from memory
        while MainScene.bodySegments.count > 2 {
            MainScene.bodySegments.removeLast()
        }
        
    }
    
    // Updates the graphics of the snake when the snake moves
    public static func moveSnake() {
        
        /// Move the head
        if head.position != CGPoint(x: (convertToBoardX(coordinate: Snake.position[0])), y: (convertToBoardY(coordinate: Snake.position[0]))) {
            head.run(SKAction.move(to: CGPoint(x: (convertToBoardX(coordinate: Snake.position[0])), y: (convertToBoardY(coordinate: Snake.position[0]))), duration: moveDuration))
        }
        
        /// Move the body
        for i in 0..<bodySegments.count {
                bodySegments[i].run(SKAction.move(to: CGPoint(x: (convertToBoardX(coordinate: Snake.position[i+1])), y: (convertToBoardY(coordinate: Snake.position[i+1]))), duration: moveDuration))
        }
    }
    
    // Moves the food when needed
    public static func moveFood() {
        
        /// Update the score
        MainScene.updateScore()
        
        /// Remove the food from the screen
        food.removeFromParent()
        
        /// Remove the food from memory
        foods.removeAll()
        
        /// Get new coordinates from the food class
        Food.moveFood()
        var isValidPos: Bool = false
        
        /// Find a valid position for it
        while !isValidPos {
            isValidPos = true
            /// Checks to see if the current desired position is inside of the snake
            for i in 0..<Snake.position.count {
                if Food.x == Snake.position[i].x && Food.y == Snake.position[i].y {
                    moveFood()
                    isValidPos = false
                }
            }
            /// Adjusts for some errors that can occur
            if Food.y > 10 {
                let ran = Int.random(in: 0...3)
                if ran != 0 {
                    isValidPos = false
                }
            }
        }
        
        /// Create the new food
        food = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        food.position = CGPoint(x: (-436.5)+Double((Food.x*30)), y: (-309)+Double((Food.y*30)))
        food.alpha = 0.0
        /// Remove old foods
        for i in MainScene.foods {
            i.removeFromParent()
        }
        
    }
    
    // Adds a body segment to the snake when a food is eaten
    public func addSegment() {
        /// Generates the new segment
        let body = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        body.fillColor = SKColor.white
        body.alpha = 0.0
        body.position = CGPoint(x: (MainScene.convertToBoardX(coordinate: Snake.position[Snake.position.count-1])), y: (MainScene.convertToBoardY(coordinate: Snake.position[Snake.position.count-1])))
        /// Adds it to the list of other body segments
        MainScene.bodySegments.append(body)
        /// Displays
        self.addChild(body)
        body.run(fadeIn)
    }
    
    /*
     
     Before each frame:
     1. Check to see if the snake has eaten a food
     2. Check to see if there is a food displayed
     
     */
    public override func update(_ currentTime: TimeInterval) {
        
        /// Has the snake eaten a food
        if Snake.position.count-1 != MainScene.bodySegments.count {
            addSegment()
            MainScene.moveFood()
        }
        
        /// Is there a food displayed
        if MainScene.foods.count == 0 {
            MainScene.foods.append(MainScene.food)
            self.addChild(MainScene.food)
            MainScene.food.run(fadeIn)
        }
        
    }
}
