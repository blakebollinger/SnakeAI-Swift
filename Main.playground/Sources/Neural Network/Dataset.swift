//
//  Dataset.swift
//  SnakeAI
//

/*

Class for the declaration and maintiaining of the neural network's training data

*/

import Foundation


public extension NeuralNet {
    
    struct Dataset {
        
        public enum Error: Swift.Error {case data(String)}
        public let trainInputs: [[Float]]
        public let trainLabels: [[Float]]
        public let validationInputs: [[Float]]
        public let validationLabels: [[Float]]
        
        public init(trainInputs: [[[Float]]], trainLabels: [[[Float]]],
                    validationInputs: [[[Float]]], validationLabels: [[[Float]]]) throws {
            guard !trainInputs.isEmpty,
                !trainInputs[0].isEmpty,
                !trainInputs[0][0].isEmpty else {
                    throw Error.data("The training data contains one or more empty sets.")
            }
            guard !trainLabels.isEmpty,
                !trainLabels[0].isEmpty,
                !trainLabels[0][0].isEmpty else {
                    throw Error.data("The training labels contains one or more empty sets.")
            }
            guard !validationInputs.isEmpty,
                !validationInputs[0].isEmpty,
                !validationInputs[0][0].isEmpty else {
                    throw Error.data("The validation data contains one or more empty sets.")
            }
            guard !validationLabels.isEmpty,
                !validationLabels[0].isEmpty,
                !validationLabels[0][0].isEmpty else {
                    throw Error.data("The training labels contains one or more empty sets.")
            }
            let numTrainingBatches = trainInputs.count
            let batchSize = trainInputs[0].count
            let inputSize = trainInputs[0][0].count
            let numValidationBatches = validationInputs.count
            let outputSize = trainLabels[0][0].count
            let trainSet = [Float](repeatElement(0, count: batchSize * inputSize))
            var trainBatches: [[Float]] = [[Float]](repeatElement(trainSet, count: numTrainingBatches))
            for batch in 0..<numTrainingBatches {
                for row in 0..<batchSize {
                    for col in 0..<inputSize {
                        let idx = row * inputSize + col
                        trainBatches[batch][idx] = trainInputs[batch][row][col]
                    }
                }
            }
            
            let trainLabelSet = [Float](repeatElement(0, count: batchSize * outputSize))
            var trainLabelBatches: [[Float]] = [[Float]](repeatElement(trainLabelSet, count: numTrainingBatches))
            for batch in 0..<numTrainingBatches {
                for row in 0..<batchSize {
                    for col in 0..<outputSize {
                        let idx = row * outputSize + col
                        trainLabelBatches[batch][idx] = trainLabels[batch][row][col]
                    }
                }
            }

            let validationSet = [Float](repeatElement(0, count: batchSize * inputSize))
            var validationBatches: [[Float]] = [[Float]](repeatElement(validationSet, count: numValidationBatches))
            for batch in 0..<numValidationBatches {
                for row in 0..<batchSize {
                    for col in 0..<inputSize {
                        let idx = row * inputSize + col
                        validationBatches[batch][idx] = validationInputs[batch][row][col]
                    }
                }
            }
            
            let validationLabelSet = [Float](repeatElement(0, count: batchSize * outputSize))
            var validationLabelBatches: [[Float]] = [[Float]](repeatElement(validationLabelSet, count: numValidationBatches))
            for batch in 0..<numValidationBatches {
                for row in 0..<batchSize {
                    for col in 0..<outputSize {
                        let idx = row * outputSize + col
                        validationLabelBatches[batch][idx] = validationLabels[batch][row][col]
                    }
                }
            }

            try self.init(trainInputs: trainBatches, trainLabels: trainLabelBatches,
                          validationInputs: validationBatches, validationLabels: validationLabelBatches)
        }
        
        public init(trainInputs: [[Float]], trainLabels: [[Float]],
                    validationInputs: [[Float]], validationLabels: [[Float]]) throws {
            guard trainInputs.count == trainLabels.count && validationInputs.count == validationLabels.count else {
                throw Error.data("The number of input sets provided for training/validation must equal the number of label sets provided.")
            }
            

            self.trainInputs = trainInputs
            self.trainLabels = trainLabels
            self.validationInputs = validationInputs
            self.validationLabels = validationLabels
        }
        
    }
    
}
