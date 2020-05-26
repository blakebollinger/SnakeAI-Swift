//
//  Cache.swift
//  SnakeAI
//

/*
 
 Caches the data that the neural netowrk needs when the neural network is intialized
 
 */


import Foundation


internal extension NeuralNet {
    
    struct Cache {

        public let layerWeightCounts: [Int]

        var layerWeights: [[Float]]
        var previousLayerWeights: [[Float]]
        var newLayerWeights: [[Float]]
        var layerWeightMomentumDeltas: [[Float]]
        var layerBiases: [[Float]]
        var previousLayerBiases: [[Float]]
        var newLayerBiases: [[Float]]
        var layerBiasMomentumDeltas: [[Float]]
        var layerOutputs: [[Float]]
        var layerOutputDerivatives: [[Float]]
        var layerErrors: [[Float]]
        
        
        init(structure: NeuralNet.Structure) {
            // Layer outputs cache
            self.layerOutputs = []
            self.layerOutputDerivatives = []
            for layer in 0..<structure.numLayers {
                let matrix = [Float](repeatElement(0, count: structure.batchSize * structure.layerNodeCounts[layer]))
                self.layerOutputs.append(matrix)
                self.layerOutputDerivatives.append(matrix)
            }
            
            // Weights cache
            self.layerWeights = [[]] // Empty set for first layer
            self.previousLayerWeights = [[]]
            self.newLayerWeights = [[]]
            self.layerWeightMomentumDeltas = [[]]
            for layer in 1..<structure.numLayers {
                let matrix = [Float](repeatElement(0, count: structure.layerNodeCounts[layer - 1] * structure.layerNodeCounts[layer]))
                self.layerWeights.append(matrix)
                self.previousLayerWeights.append(matrix)
                self.newLayerWeights.append(matrix)
                self.layerWeightMomentumDeltas.append(matrix)
            }
            
            // Weight counts for for each layer
            var weightCounts = [Int]()
            for (index, layer) in structure.layerNodeCounts.enumerated() {
                if index == 0 {
                    // Input layer has no weights
                    weightCounts.append(0)
                } else {
                    weightCounts.append(structure.layerNodeCounts[index - 1] * layer)
                }
            }
            self.layerWeightCounts = weightCounts
            
            // Biases
            self.layerBiases = [[]] // Empty set for first layer
            self.previousLayerBiases = [[]]
            self.newLayerBiases = [[]]
            self.layerBiasMomentumDeltas = [[]]
            for layer in 1..<structure.numLayers {
                let row = [Float](repeatElement(0, count: structure.layerNodeCounts[layer]))
                self.layerBiases.append(row)
                self.previousLayerBiases.append(row)
                self.newLayerBiases.append(row)
                self.layerBiasMomentumDeltas.append(row)
            }
            
            // Errors cache
            self.layerErrors = []
            for layer in 0..<structure.numLayers {
                self.layerErrors.append([Float](repeatElement(0, count: structure.layerNodeCounts[layer] * structure.batchSize)))
            }
        }
        
    }
    
}
