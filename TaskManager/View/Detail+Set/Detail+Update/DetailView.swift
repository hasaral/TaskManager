//
//  DetailSetView 2.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI
import CoreData

struct DetailView: View {
    @State private var isLoading: Bool = false
    @State private var isLoadingGradient: Bool = false
    @State private var showSignUp: Bool = false
    @State private var streamTask: Task<Void, Never>?
    @State private var isScrolledDown: Bool = false
    @State private var scrollToTop: Bool = false
    @Binding var hideButton: Bool
    @ObservedObject var item: Item
    @State var priority = 0
    
    @State var date = Date()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all)
            VStack {
                GenerateUpdateCard(
                    isLoading: $isLoading,
                    onUpdate: updateItem,date: $date, priority: $priority, item: item
                )
            }
            .padding()
            .padding(.top, 20)
            
            if isLoadingGradient {
                AnimatedMeshGradient()
                    .mask(
                        RoundedRectangle(cornerRadius: 44)
                            .stroke(lineWidth: 44)
                            .blur(radius: 22)
                    )
                    .ignoresSafeArea()
            }
        }.onAppear {
            priority = Int(item.priority)
            hideButton = true
        }.onDisappear {
            hideButton = false
        }
    }
    
    private func updateItem() async {
        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            isLoadingGradient = true
        }
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

struct EditItemConfig: Identifiable {
    let id = UUID()
    let item: Item
    let childContext: NSManagedObjectContext
    
    init?(itemObjectID: NSManagedObjectID, context: NSManagedObjectContext) {
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = context
        guard let existingItem = self.childContext.object(with: itemObjectID) as? Item else { return nil }
        self.item = existingItem
    }
}

struct detailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(hideButton: .constant(false), item: Item.init())
            .preferredColorScheme(.light)
    }
}
