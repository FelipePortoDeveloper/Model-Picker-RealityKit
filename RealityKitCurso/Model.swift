//
//  Model.swift
//  RealityKitCurso
//
//  Created by Felipe Porto on 03/07/24.
//

import UIKit
import RealityKit
import Combine

class Model
{
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        
        self.image = UIImage(named: modelName)!
        
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: {
                loadCompletion in
                
                
            }, receiveValue: {
                modelEntity in
                
                // Onde recebe o modelEntity
                
                self.modelEntity = modelEntity
                if self.modelEntity != nil {
                    print("Carregou com sucesso a modelEntity com o modelName: \(modelName)")
                }
            })
        
    }
}
