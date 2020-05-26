//
//  Coordinate.swift
//  Snake-AI
//

/*

Handles all coordinates related to the snake game "board"
 
 Originates in bottom left corner

*/
public class Coordinate {

    // Initialize variables
    public var x: Int
    public var y: Int
    
    // Regualr initializer with passed coordinates
    init(xPos: Int, yPos: Int) {
        x = xPos
        y = yPos
    }
    
    // Other intializer used when new random coordinates are needed (Ex. New snake)
    init() {
        x = Int.random(in: 5...15)
        y = Int.random(in: 5...15)
    }
    
}

