//
//  Snake.swift
//  Snake-AI
//

/*

 Handles:
 
 1. All parts of the snake
 2. Updating the position of the snake
 3. Detecting when a snake has moved into an incorrect position
 4. The snake's actions on a game's ending
 5. The score
 
*/

import SpriteKit

public class Snake {
    
    public static var direction: Int = 0
    public static var position: [Coordinate] = []
    public static var score = 0
    
    
    // Called at beginning of the game to initialize the snake
    public init() {
        
        /// Pick a random direction and starting coordinates
        Snake.direction = Int.random(in: 0...3)
        Snake.position.append(Coordinate())

        /// Generate the snake based on the randomized variables above
        switch Snake.direction {
            case 0:
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)-1))
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)-2))
            case 1:
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)-1, yPos: Snake.position[0].y))
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)-2, yPos: Snake.position[0].y))
            case 2:
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)+1))
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)+2))
            case 3:
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)+1, yPos: Snake.position[0].y))
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)+2, yPos: Snake.position[0].y))
            default:
                print("Welp...Something went wrong in initializing the snake's direction")
        }
        
    }
    
    
    // Called on each game step to update the snakes positon and move 1 space forward
    public func updatePosition() {
        
        /// Update each body segment to take the place of the body segment before it
        for i in stride(from: Snake.position.count-1, to: 0, by: -1) {
            Snake.position[i].x = Snake.position[i-1].x
            Snake.position[i].y = Snake.position[i-1].y
        }
        
        /// Update the head of the snake to move one space in the desired direction
        switch Snake.direction {
        case 0:
            Snake.position[0].y = Snake.position[0].y+1
        case 1:
            Snake.position[0].x = Snake.position[0].x+1
        case 2:
            Snake.position[0].y = Snake.position[0].y-1
        case 3:
            Snake.position[0].x = Snake.position[0].x-1
        default:
            print("Error updating snake position")
        }
        
    }
    
    // Called on a game's end to reset the game
    public static func endGame() {
        
        /// End the graphics on the screen
        MainScene.endGame()
        
        /// Reset snake parameters
        Snake.direction = 0
        Snake.position = []
        Snake.score = 0
        
        /// Re-initialize the snake
        Snake.direction = Int.random(in: 0...3)
        Snake.position.append(Coordinate())
        
        /// Create the body of the new snake
        switch Snake.direction {
            case 0:
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)-1))
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)-2))
            case 1:
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)-1, yPos: Snake.position[0].y))
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)-2, yPos: Snake.position[0].y))
            case 2:
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)+1))
                Snake.position.append(Coordinate(xPos: Snake.position[0].x, yPos: (Snake.position[0].y)+2))
            case 3:
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)+1, yPos: Snake.position[0].y))
                Snake.position.append(Coordinate(xPos: (Snake.position[0].x)+2, yPos: Snake.position[0].y))
            default:
                print("Welp...Something went wrong in initializing the snake's direction")
        }
    }
    
    // Checks after each position update to make sure the snake can move there or if there is food there
    public static func handlePosition() {
        
        /// Can the snake move there
            /// Is the snake out of bounds
        if (Snake.position[0].x < 0 || Snake.position[0].y >= 20 ||
            Snake.position[0].y < 0 || Snake.position[0].x >= 20) {
            Game.endGame()
        }
        
        /// Is the snake running into its own body
        for i in 1..<Snake.position.count {
            if Snake.position[0].x == Snake.position[i].x && Snake.position[0].y == Snake.position[i].y {
                Game.endGame()
                break
            }
        }
        
        /// Is there food on the current space
        if Snake.position[0].x == Food.x && Snake.position[0].y == Food.y {
            Snake.position.append(Coordinate(xPos: (Snake.position[Snake.position.count-1].x), yPos: Snake.position[Snake.position.count-1].y))
            Food.moveFood()
            score += 1
        }
        
    }
    
    
}

