//
//  Activation.swift
//  Snake-AI
//

/*

Processes all of the hidden and output activation functions

*/

import Foundation
import Accelerate


public extension NeuralNet {
    
    enum ActivationFunction {
        
        public enum Hidden {
            case rectifiedLinear
            static func from(_ string: String) -> ActivationFunction.Hidden? {
                switch string {
                case "ReLU":
                    return ActivationFunction.Hidden.rectifiedLinear
                default:
                    return nil
                }
            }
            func stringValue() -> String {
                switch self {
                case .rectifiedLinear:
                    return "ReLU"
                }
            }
                
            
            public func computeActivation(_ x: [Float], result: inout [Float], rows: Int, cols: Int) {
                switch self {
                case .rectifiedLinear:
                    for i in 0..<(rows * cols) {
                        result[i] = max(0, x[i])
                    }
                }
            }
            
            public func calculateDerivative(_ y: [Float], result: inout [Float], rows: Int, cols: Int) {
                switch self {
                case .rectifiedLinear:
                    for i in 0..<(rows * cols) {
                        result[i] = y[i] == 0 ? 0 : 1
                    }
                }
            }
            
        }

        
        
        public enum Output {

            case softmax
            
            static func from(_ string: String) -> ActivationFunction.Output? {
                switch string {
                case "softmax":
                    return ActivationFunction.Output.softmax
                default:
                    return nil
                }
            }
            
            func stringValue() -> String {
                switch self {
                case .softmax:
                    return "softmax"
                }
            }
            
            public func computeActivation(_ x: [Float], result: inout [Float], rows: Int, cols: Int) {
                switch self {
                case .softmax:
                    for row in 0..<rows {
                        var sum: Float = 0
                        for col in 0..<cols {
                            let idx = row * cols + col
                            sum += exp(x[idx])
                        }
                        for col in 0..<cols {
                            let idx = row * cols + col
                            result[idx] = exp(x[idx]) / sum
                        }
                    }
                }
            }
            
            public func calculateErrorGradient(real: [Float], target: [Float], result: inout [Float], rows: Int, cols: Int) {
                switch self {
                case .softmax:
                    vDSP_vsub(target, 1,
                              real, 1,
                              &result, 1,
                              vDSP_Length(real.count))
                    }
            
            }
    
        }
    }
}
