//
//  ContentView.swift
//  RealityKitCurso
//
//  Created by Felipe Porto on 03/07/24.
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View
{
    
    @State private var isPlacementEnabled:Bool = false
    @State private var selectedModel:Model?
    @State private var modelConfirmedForPlacement:Model?
    
    private var models:[Model] = {
        
       // Pegar o nome dos modelos de forma dinamica
        
        let filemanager = FileManager.default
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels: [Model] = []
        
        for file in files where file.hasSuffix("usdz") {
            let modelName = file.replacingOccurrences(of: ".usdz", with: "")
            
            let model = Model(modelName: modelName)
            
            availableModels.append(model)
        }
        
        return availableModels
        
    }()
    
    var body: some View
    {
        ZStack(alignment: .bottom)
        {
            ARViewContainer(modelConfirmedForPlacement: $modelConfirmedForPlacement)
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, modelConfirmedForPlacement: $modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: $isPlacementEnabled, selectedModel: $selectedModel, models: models)
            }
            
            
            
        }
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelConfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config)
        
        _ = FocusEntity(on: arView, focus: .classic)

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) 
    {
        
        
        
        if let model = modelConfirmedForPlacement
        {
            if let modelEntity = model.modelEntity
            {
                print(model.modelName)
                
                let anchorEntity = AnchorEntity(plane: .any)
                
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                
                uiView.scene.addAnchor(anchorEntity)
            } else
            {
                print("Incapaz de carregar a modelEntity de \(model.modelName)")
            }
            
            
            DispatchQueue.main.async 
            {
                modelConfirmedForPlacement = nil
            }
        }
        
    }
    
}

struct ModelPickerView: View {
    
    @Binding var isPlacementEnabled:Bool
    @Binding var selectedModel:Model?
    
    var models:[Model]
    let size:CGFloat = 80
    
    var body: some View {
        HStack(spacing: 10)
        {
            ForEach(0 ..< models.count, id: \.self)
            {
                index in
                
                Button 
                {
                    selectedModel = self.models[index]
                    isPlacementEnabled = true
                } label: {
                    
                    Image(uiImage: models[index].image)
                        .resizable()
                        .frame(minWidth: size, maxWidth: size, minHeight: size, maxHeight: size)
                        .aspectRatio(1/1, contentMode: .fit)
                }
                
            }
            
        Spacer()
    }
    }
}

struct PlacementButtonsView: View {
    
    @Binding var isPlacementEnabled:Bool
    @Binding var selectedModel:Model?
    @Binding var modelConfirmedForPlacement:Model?
    
    var body: some View {
        HStack
        {
            // Botão de cancelar
            Button
            {
                self.resetPlacementParameters()
            } label:
            {
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .tint(.black)
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(20)
            }
            
            // Botão de confirmar
            
            Button
            {
                self.modelConfirmedForPlacement = self.selectedModel
                self.resetPlacementParameters()
            } label:
            {
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .tint(.black)
                    .background(Color.white.opacity(0.75))
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters()
    {
        self.selectedModel = nil
        self.isPlacementEnabled = false
    }
}



#Preview {
    ContentView()
}
