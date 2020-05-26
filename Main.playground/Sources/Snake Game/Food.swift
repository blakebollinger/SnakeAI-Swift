//
//  Food.swift
//  Snake-AI
//

/*

Declares and maintains all instances of food in the snake game

*/

public class Food {
    
    // Initialize variables
    public static var x: Int = 0
    public static var y: Int = 0
    public static var eaten = false

    // Initialize the food
    public init() {
        
        /// Randomize coordinates
        Food.x = Int.random(in: 0...19)
        Food.y = Int.random(in: 0...19)
        
    }
    
    // Generate new coordinates when the food needs to be moved (New game or eaten)
    public static func moveFood() {
        
        /// Randomize coordinates
        Food.x = Int.random(in: 0...19)
        Food.y = Int.random(in: 0...19)
        
    }
    
    
    
}

