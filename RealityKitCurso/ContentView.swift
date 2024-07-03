//
//  ContentView.swift
//  RealityKitCurso
//
//  Created by Felipe Porto on 03/07/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        Text("Hello World")
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
