//
//  Game.swift
//  Snake-AI
//

/*

 Backbone of the snake game
     
 Handles:
 
 1. All timing of the game
 2. Training for the neural network as the game starts
 3. Converting neural net output to game input
 
*/

import UIKit

public class Game {
    
    // Intiializes variables for the game and neural net
    public static var interval: Double = 1.0
    public var snake: Snake
    var structure: NeuralNet.Structure
    var nn: NeuralNet
    public static var outputs: Array<Array<Float>> = [[]]
    var dataset: NeuralNet.Dataset
    public static var neuralNet = true

    
    // Provides default values for the game variables
    public init(interval: Double) {
        Game.self.interval = interval
        snake = Snake()
        
        structure = try! NeuralNet.Structure(nodes: [5, 100, 100, 100, 4],
                                                hiddenActivation: .rectifiedLinear, outputActivation: .softmax,
                                                batchSize: 1, learningRate: 0.8, momentum: 0.9)
        
        dataset = try! NeuralNet.Dataset(trainInputs: TrainingData.myTrainingData,
                                         trainLabels: TrainingData.myTrainingLabels,
                                         validationInputs: TrainingData.myValidationData,
                                         validationLabels: TrainingData.myValidationLabels)
        
        nn = try! NeuralNet(structure: structure)
        
        Game.outputs = [[]]
        
    }
    
    // Increases the speed of the game
    public static func increaseSpeed() {
        /// Change to a different speed based on the current speed
        switch Game.interval {
        case 2:
            Game.interval = 1.5
            break
        case 1.5:
            Game.interval = 1
            break
        case 1:
            Game.interval = 0.5
            break
        case 0.5:
            Game.interval = 0.25
            break
        default:
            break
        }
        
    }
    
    // Decreases the speed of the game
    public static func decreaseSpeed() {
        /// Change to a different speed based on the current speed
        switch Game.interval {
        case 0.25:
            Game.interval = 0.5
            break
        case 0.5:
            Game.interval = 1
            break
        case 1:
            Game.interval = 1.5
            break
        case 1.5:
            Game.interval = 2
            break
        default:
            break
        }
        
    }
    
    // Begins training the neural network
    public func train() {
        /// Calls out to the neural net class to handle training
        _ = try! nn.train(dataset, maxEpochs: 100, errorThreshold: 0.000000001, errorFunction: .meanSquared, epochCallback: nil)
    }
    
    // Starts the game
    public func startGame() {
        
        /// Begins a timer to handle the speed of the game
        _ = Timer.scheduledTimer(withTimeInterval: Game.interval, repeats: false) { timer in
            self.stepGame()
        }

        
    }
    
    // Convert neural net output to usable game input
    func computeMove(array: [Float]) {
        
        var arr = array
        /// It is impossible to turn 180 degrees in one step
        /// So the tendency to do that will be 0 as set below
        switch Snake.direction {
        case 0:
            arr[2] = 0
        case 1:
            arr[3] = 0
        case 2:
            arr[0] = 0
        case 3:
            arr[1] = 0
        default:
            print("Error in computeMove")
        }
        
        /// Finds the directional highest value output by the neural net and moves in that direction
        if arr.firstIndex(of: arr.max()!) == 0 {
            Snake.direction = 0
        } else if arr.firstIndex(of: arr.max()!) == 1 {
            Snake.direction = 1
        } else if arr.firstIndex(of: arr.max()!) == 2 {
            Snake.direction = 2
        } else if arr.firstIndex(of: arr.max()!) == 3 {
            Snake.direction = 3
        }
        
    }
    
    // Moves the game forward one step
    func stepGame() {
        
        /// Updates snake position
        snake.updatePosition()
        
        /// Preforms actions appropriately based on the new position (Ex. Die and end game)
        Snake.handlePosition()
        
        /// Update the snake graphically
        MainScene.moveSnake()
        
        /// If the neural net is on, preform the neural net's desured action
        if Game.neuralNet {
            computeMove(array: try! nn.infer(GameFeatures.generateOutput()))
        }
        
        /// Set a timer for the next game step
        _ = Timer.scheduledTimer(withTimeInterval: Game.interval, repeats: false) { timer in
            self.stepGame()
        }
        
    }
    
    // End the game for the snake if the game has ended
    public static func endGame() {
        
        Snake.endGame()
        
    }
    
}

