//
//  GameFeatures.swift
//  SnakeAI
//

/*

 Takes the curresn state of the game and generates featrues (input) for the neural net
 
*/

import Foundation

public class GameFeatures {
    
    // Stitches together the data
    public static func generateOutput() -> Array<Float> {

        var output: Array<Float> = []
        
        /// Is there an object above the snake (Wall or body)
        for i in 1..<Snake.position.count {
            if (Snake.position[0].y + 1 == Snake.position[i].y &&
                    Snake.position[0].x == Snake.position[i].x) {
                output.append(1);
                break;
            } else if (Snake.position[0].y + 1 == 20) {
                output.append(1);
                break;
            }
        }
        
        /// If not add a "0"
        if (output.count == 0) {
            output.append(0);
        }
        
        /// Is there an object to the right of the snake (Wall or body)
        for i in 1..<Snake.position.count {
            if (Snake.position[0].x + 1 == Snake.position[i].x &&
                    Snake.position[0].y == Snake.position[i].y) {
                output.append(1);
                break;
            }
            if (Snake.position[0].x + 1 == 20) {
                output.append(1);
                break;
            }
        }

        /// If not add a "0"
        if (output.count == 1) {
            output.append(0);
        }
            
        /// Is there an object below the snake
        for i in 1..<Snake.position.count {
            if (Snake.position[0].y - 1 == Snake.position[i].y &&
                    Snake.position[0].x == Snake.position[i].x) {
                output.append(1);
                break;
            }
            if (Snake.position[0].y - 1 == -1) {
                output.append(1);
                break;
            }
        }
        /// If not add a "0"
        if (output.count == 2) {
            output.append(0);
        }
        
        /// Is there an object to the left of the snake
        for i in 1..<Snake.position.count {
            if (Snake.position[0].x - 1 == Snake.position[i].x &&
                    Snake.position[0].y == Snake.position[i].y) {
                output.append(1);
                break;
            }
            if (Snake.position[0].x - 1 == -1) {
                output.append(1);
                break;
            }
        }

        /// If not add a "0"
        if (output.count == 3) {
            output.append(0);
        }
        
        /// Append the calculated angle
        output.append(calcAngle())

        return output;

    }
    
    // Calculates the angle between the food and the snake
    public static func calcAngle() -> Float {

        /// If the snake is to the left of the food return a negative
        if Food.x > Snake.position[0].x {
            let tan: Float = Float(Food.y-Snake.position[0].y)/Float(Food.x-Snake.position[0].x)
            return -(atan(tan)+(Float.pi/2))
        
        /// If the snake is to the left of the food return a positive
        } else  if Food.x < Snake.position[0].x {
            let tan: Float = Float(Food.y-Snake.position[0].y)/Float(Snake.position[0].x-Food.x)
            return (atan(tan)+(Float.pi/2))
        }
        
        /// If the snake is directly below the food return pi
        if Food.y > Snake.position[0].y {
            return Float.pi
            
        /// If the snake is drectly above the food return 0
        } else {
            return 0.0
        }
    }
}

    
