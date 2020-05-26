//
//  Error.swift
//  SnakeAI
//

/*

Calculates the error while training the neural network

*/

import Foundation


public extension NeuralNet {
    enum ErrorFunction {
        case meanSquared
        public func computeError(real: [Float], target: [Float], rows: Int, cols: Int) -> Float {
            switch self {
            case .meanSquared:
                let sum = zip(real, target).reduce(0) { (sum, pair) -> Float in
                    return (pair.0 - pair.1) * (pair.0 - pair.1)
                }
                return sum / Float(real.count)
            }
        }
        
    }
    
}
