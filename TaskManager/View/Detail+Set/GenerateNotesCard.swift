//
//  GenerateNotesCard.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI

struct GenerateNotesCard: View {
    @Binding var inputText: String
    @Binding var isLoading: Bool
    let onGenerate: () async -> Void
    @Environment(\.colorScheme) var colorScheme
    @State var isAnimating = false
    @Binding var title: String
    @Binding var date: Date
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var priority : Int
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Add Task")
                .customAttribute(EmphasisAttribute())
                .transition(isLoading ? TextTransition(): .init())
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .accessibilityElement()
                .accessibilityLabel(Text("Add task view"))
            
            Picker("Priority", selection: $priority) {
                Text("Low").tag(0)
                    .accessibilityElement()
                    .accessibilityLabel(Text("Low Priority"))
                Text("Med").tag(1)
                    .accessibilityElement()
                    .accessibilityLabel(Text("Medium Priority"))
                Text("High").tag(2)
                    .accessibilityElement()
                    .accessibilityLabel(Text("High Priority"))
            }.pickerStyle(.segmented)
                .padding()
                .onChange(of: priority, { oldValue, newValue in
                    priority = Int(Int64(newValue))
                })
                .padding(.top, -10)
            
            TextField("Title", text: $title)
                .accessibilityIdentifier("TaskTextField")
                .focused($isTextFieldFocused)
                .font(.headline)
                .foregroundStyle(.black)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.primary.opacity(0.1), lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
                )
                .padding(.horizontal, 15)
                .padding(.top, -10)
            //                .accessibilityElement()
            //                .accessibilityLabel(Text("Task Title"))
            
            TextEditor(text: $inputText)
                .accessibilityIdentifier("TextEditorAdd")
                .frame(height: 200)
                .padding()
                .foregroundStyle(.black)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.primary.opacity(0.1), lineWidth: 1)
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 5)
                )
                .padding()
                .scaleEffect(isAnimating ? 1.1 : 1)
//                .accessibilityElement()
//                .accessibilityLabel(Text("Task Description"))
            
            DatePicker("Select Time",
                       selection: $date,
                       in: Date()...,
                       displayedComponents: [.date, .hourAndMinute])
            .accessibilityIdentifier("DatePickerAdd")
            .padding()
//            .accessibilityElement()
//            .accessibilityLabel(Text("Select task time"))
            
            Spacer()
            PrimaryButton(isLoading: isLoading, isDisabled: title.isEmpty) {
                Task {
                    await onGenerate()
                }
            }
            .accessibilityElement()
            .accessibilityLabel(Text("Add task save button"))
            .padding(.horizontal, 32)
            .padding()
            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Dismiss") {
                    self.endTextEditing()
                }
                .accessibilityIdentifier("DismissButton")
                .accessibilityElement()
                .accessibilityLabel(Text("keyboard dismiss button"))
            }
        }
        .background(Color(.white))
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .frame(maxHeight: .infinity)
    }
    
}
struct EmphasisAttribute: TextAttribute {}

#Preview {
    GenerateNotesCard(
        inputText: .constant("Sample input text"),
        isLoading: .constant(false),
        onGenerate: { }, title: .constant(""), date: .constant(Date()), priority: .constant(0)
    )
    .frame(maxHeight: .infinity)
    .padding(.horizontal)
    .background(Color(.systemGray6))
}
