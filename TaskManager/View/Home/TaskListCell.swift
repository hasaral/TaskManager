//
//  TaskListCell.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//

import SwiftUI


struct TaskListCell: View {
    let item: Item
    @Environment(\.redactionReasons) var redactionReasons
    
    var body: some View {
        LazyHStack(alignment: .top, spacing: 40) {
            
            Image("Illustration 1")
                .resizable()
                .frame(width: 36, height: 36)
                .mask(Circle())
                .padding(12)
                .background(Color(UIColor.systemBackground).opacity(0.3))
                .mask(Circle())
                .overlay(CircularView(value:1, isColor: item.isdone))
            
            LazyVStack(alignment: .leading, spacing: 8) {
                Text(item.duedate ?? Date(), formatter: itemFormatter)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, -10)
                    .accessibilityElement()
                    .accessibilityLabel(Text("Task due date: \(item.duedate ?? Date())"))
                
                Text(item.titles ?? "")
                    .multilineTextAlignment(.trailing)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .accessibilityElement()
                    .accessibilityLabel(Text("Task title: \(item.titles ?? "")"))
                
                Text(item.descriptions ?? "")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .accessibilityElement()
                    .accessibilityLabel(Text("Task description: \(item.descriptions ?? "")"))
                
                if item.isdone {
                    Text("Done")
                        .accessibilityElement()
                        .accessibilityLabel(Text("Task is done"))
                } else {
                    if Date() < item.duedate! {
                        ProgressView(timerInterval: Date()...(item.duedate ?? Date()), countsDown: true)
                    } else {
                        Text("Time is up")
                            .accessibilityElement()
                            .accessibilityLabel(Text("Time is up"))
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

struct CircularView: View {
    var value: CGFloat = 0.5
    var lineWidth: Double = 6
    var isColor: Bool = false
    
    @State var appear = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: appear ? value : 0)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            .fill(.angularGradient(colors:isColor ? [.green, .white, .green] : [.gray] , center: .center, startAngle: .degrees(0), endAngle: .degrees(360)))
            .rotationEffect(.degrees(270))
            .onAppear {
                if !appear {
                    withAnimation(.spring().delay(0.5)) {
                        appear = true
                    }
                }
            }
            .onDisappear {
                appear = false
            }
    }
}



