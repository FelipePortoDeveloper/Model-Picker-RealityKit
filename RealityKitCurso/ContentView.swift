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
            ARViewContainer()
            ModelPickerView(models: models)
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

struct ModelPickerView: View {
    
    var models:[String]
    let size:CGFloat = 80
    
    var body: some View {
        HStack(spacing: 10)
        {
            ForEach(0 ..< models.count, id: \.self)
            {
                index in
                
                Button {} label: {
                    
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

#Preview {
    ContentView()
}
