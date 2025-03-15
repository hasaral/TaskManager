//
//  DetailSetView.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//

import SwiftUI

struct DetailSetView: View {
    @State private var inputText: String = ""
    @State private var isLoading: Bool = false
    @State private var isLoadingGradient: Bool = false
    @State private var showSignUp: Bool = false
    @State private var streamTask: Task<Void, Never>?
    @State private var isScrolledDown: Bool = false
    @State private var scrollToTop: Bool = false
    @State private var title: String = ""
    @State private var priority: Int = 0
    
    @Binding var hideButton: Bool
    
    @State var date = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                GenerateNotesCard(
                    inputText: $inputText,
                    isLoading: $isLoading,
                    onGenerate: addItem,
                    title: $title, date: $date, priority: $priority
                )
            }
            .padding()
            .padding(.top, 10)
            if isLoadingGradient {
                AnimatedMeshGradient()
                    .mask(
                        RoundedRectangle(cornerRadius: 44)
                            .stroke(lineWidth: 44)
                            .blur(radius: 22)
                    )
                    .ignoresSafeArea()
            }
        }.onAppear{
            hideButton = true
        }.onDisappear {
            hideButton = false
        }
    }
    
    private func addItem() async {
        guard !title.isEmpty else { return }
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            isLoadingGradient = true
        }
        
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.titles = title
        newItem.descriptions = inputText
        newItem.duedate = date
        newItem.priority = Int64(priority)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DetailSetView(hideButton: .constant(false))
            .preferredColorScheme(.light)
    }
}
