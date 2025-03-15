//
//  AnimatedMeshGradient.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI

struct AnimatedMeshGradient: View {
    @State var appear = false
    @State var appear2 = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [appear2 ? 0.5 : 1.0, 0.0], [1.0, 0.0],
                [0.0, 0.5], appear ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
                [0.0, 1.0], [1.0, appear2 ? 2.0 : 1.0], [1.0, 1.0]
            ], colors: [
                appear2 ? .green : .blue, appear2 ? .green : .cyan, .orange,
                appear ? .white : .green, appear ? .green : .white, appear ? .green : .white,
                appear ? .green : .cyan, appear ? .mint : .blue, appear2 ? .green : .blue
            ]
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                appear.toggle()
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                appear2.toggle()
            }
        }
    }
}

struct AnimatedButtonGradient: View {
    @State var appear = false
    @State var appear2 = false
    
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [appear2 ? 0.5 : 1.0, 0.0], [1.0, 0.0],
                [0.0, 0.5], appear ? [0.1, 0.5] : [0.8, 0.2], [1.0, -0.5],
                [0.0, 1.0], [1.0, appear2 ? 2.0 : 1.0], [1.0, 1.0]
            ], colors: [
                appear2 ? .green : .white, appear2 ? .white : .green,
                appear ? .white : .green, appear ? .green : .white, appear ? .white : .green,
                appear ? .green : .white, appear ? .white : .green, appear2 ? .green : .white
            ]
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                appear.toggle()
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                appear2.toggle()
            }
        }
    }
}

#Preview {
    AnimatedButtonGradient()
        .ignoresSafeArea()
}
