//
//  Snackbar.swift
//  TaskManager
//
//  Created by Hasan Saral on 14.03.2025.
//


import SwiftUI

struct Snackbar: View {
    var message: String
    var actionText: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(message)
                .foregroundColor(.white)
                .padding(.horizontal)

            if let actionText = actionText, let action = action {
                Spacer()
                Button(actionText) {
                    action()
                }
                .foregroundColor(.yellow)
                .padding(.trailing)
            }
        }
        .padding()
        .background(Color.green.opacity(0.8))
        .cornerRadius(8)
        .shadow(radius: 4)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeInOut, value: UUID())
    }
}
