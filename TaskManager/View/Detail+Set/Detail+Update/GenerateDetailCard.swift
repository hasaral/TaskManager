//
//  GenerateNotesCard.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI

struct GenerateUpdateCard: View {
    @Binding var isLoading: Bool
    let onUpdate: () async -> Void
    @Environment(\.colorScheme) var colorScheme
    @State var isAnimating = false
    @Binding var date: Date
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Binding var priority : Int
    @ObservedObject var item: Item
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Edit Task")
                .customAttribute(EmphasisAttribute())
                .transition(isLoading ? TextTransition(): .init())
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .accessibilityElement()
                .accessibilityLabel(Text("Edit Task view"))
            
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
                    item.priority = Int64(newValue)
                })
                .padding(.top, -20)
                .accessibilityElement()
                .accessibilityLabel(Text("Edit Priority"))
            
            TextField("Title", text: Binding(get: {
                item.titles ?? ""
            }, set: { newValue in
                item.titles = newValue
            }))
            .keyboardShortcut("n", modifiers: [.command])
            .accessibilityElement()
            .accessibilityLabel(Text("Edit Title \(item.titles ?? "")"))
            .font(.subheadline)
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
            .padding(.top, -10)
            .padding(.horizontal, 20)
            
            TextEditor(text: Binding(get: {
                item.descriptions ?? ""
            }, set: { newValue in
                item.descriptions = newValue
            }))
            .accessibilityElement()
            .accessibilityLabel(Text("Edit description \(item.descriptions ?? "")"))
            .frame(height: 200)
            .font(.subheadline)
            .foregroundStyle(.black)
            .padding()
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
            
            Text(item.duedate ?? Date(), formatter: itemFormatter)
                .accessibilityElement()
                .accessibilityLabel(Text(item.duedate ?? Date(), formatter: itemFormatter))
            
            DatePicker("Select Time",
                       selection: $date,
                       in: Date()...,
                       displayedComponents: [.date, .hourAndMinute])
            .padding()
            .accessibilityElement()
            .accessibilityLabel(Text("Edit date"))
            
            Toggle(item.isdone ? "Done" : "Pending",isOn: $item.isdone)
                .toggleStyle(.switch)
                .padding(.horizontal, 20)
                .padding(.top, -10)
                .accessibilityElement()
                .accessibilityLabel(Text("Edit task status"))
            
            Spacer()
            PrimaryButton(isLoading: isLoading,isEditing: true, isDisabled: item.titles!.isEmpty) {
                Task {
                    await onUpdate()
                }
            }
            .accessibilityElement()
            .accessibilityLabel(Text("Edit task save button"))
            .onChange(of: date, { oldValue, newValue in
                item.duedate = newValue
            })
            .padding(.horizontal, 32)
            .padding()
            .background(Color(.white))
            .cornerRadius(22)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .frame(maxHeight: .infinity)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Dismiss") {
                    self.endTextEditing()
                }
                .accessibilityElement()
                .accessibilityLabel(Text("Dismiss keyboard"))
            }
        }
        .background(Color(.white))
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .frame(maxHeight: .infinity)
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}

#Preview {
    GenerateUpdateCard(
        isLoading: .constant(false),
        onUpdate: { }, date: .constant(Date()), priority: .constant(0), item: Item.init())
    .frame(maxHeight: .infinity)
    .padding(.horizontal)
    .background(Color(.systemGray6))
}
