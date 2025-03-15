//
//  LoadingIndicator.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(Color.white, lineWidth: 2)
            .frame(width: 16, height: 16)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .onAppear {
                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

struct PrimaryButton: View {
    var isLoading: Bool = false
    var isEditing: Bool = false

    var isDisabled: Bool = false
    var action: () -> Void
    @State var counter: Int = 0
    @State var origin: CGPoint = .zero
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    LoadingIndicator()
                } else {
                    Image(systemName: "sparkles")
                }
                Text(isLoading ? "..." : isEditing ? "Update Task":"Add Task")
                    .foregroundStyle(.black)
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .accessibilityIdentifier("AddTaskButton")
        .background(
            ZStack {
                if !isDisabled {
                    AnimatedButtonGradient()
                        .mask(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 16)
                                .blur(radius: 8)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 3)
                                .blur(radius: 2)
                                .blendMode(.overlay)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 1)
                                .blur(radius: 1)
                                .blendMode(.overlay)
                        )
                }
            }
        )
        .background(.gray.opacity(0.1))
        .cornerRadius(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.black.opacity(0.5), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20)
        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 15)
        .foregroundColor(.white)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.primary.opacity(0.5), lineWidth: 1)
        )
        .disabled(isLoading || isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
        .onPressingChanged { point in
            if !isDisabled {
                if let point {
                    origin = point
                    counter += 1
                }
            }
        }
        .modifier(RippleEffect(at: origin, trigger: counter))
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(action: {})
        PrimaryButton(isLoading: true, action: {})
        PrimaryButton(isDisabled: true, action: {})
    }
    .padding(40)
}
