//
//  ContentView.swift
//  RealityKitCurso
//
//  Created by Felipe Porto on 03/07/24.
//

import SwiftUI
import RealityKit

struct ContentView : View
{
    
    @State private var isPlacementEnabled:Bool = false
    @State private var selectedModel:String?
    @State private var modelConfirmedForPlacement:String?
    
    private var models:[String] = {
        
       // Pegar o nome dos modelos de forma dinamica
        
        let filemanager = FileManager.default
        guard let path = Bundle.main.resourcePath, let files = try? filemanager.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        var availableModels: [String] = []
        
        for file in files where file.hasSuffix("usdz") {
            let modelName = file.replacingOccurrences(of: ".usdz", with: "")
            
            availableModels.append(modelName)
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
    
    @Binding var modelConfirmedForPlacement: String?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) 
    {
        
        if let modelName = modelConfirmedForPlacement
        {
            print(modelName)
            
            DispatchQueue.main.async 
            {
                modelConfirmedForPlacement = nil
            }
        }
        
    }
    
}

struct ModelPickerView: View {
    
    @Binding var isPlacementEnabled:Bool
    @Binding var selectedModel:String?
    
    var models:[String]
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
                    
                    Image(models[index])
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
    @Binding var selectedModel:String?
    @Binding var modelConfirmedForPlacement:String?
    
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
