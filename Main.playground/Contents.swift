

/*
 
 WELCOME TO SNAKEAI
 
 */

///  NOTE: May take a minute to compile because of type checking on training data for the neural network (About 1 min 30 sec on my 5 year old MBP 13)

/*
 
 SnakeAI is based upon a custom, fully connected, feed-forward neural network trained to play the classic game Snake.
 
 The neural network is trained in only a second when the playground is launched, and it leverages the test cases built into "Neural Network/TrainingData.swift"
 
 This training data was created by me playing the game and recording my output.
 
 I hope you enjoy!
 
 */

/// The Playgound was built by Blake Bollinger from 5/5/2020 - 5/17/2020.
/// Some code used in compliance with license from Swift-AI
/// https://github.com/Swift-AI/Swift-AI


import PlaygroundSupport
import SpriteKit
/// Displays the SKScene
var game = Game(interval: 0.5)
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = MainScene(fileNamed: "MainScene") {
    scene.scaleMode = .aspectFill
    sceneView.presentScene(scene)
}
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView

/// Trains the Neural Net
game.train()

/// Starts the game
game.startGame()
