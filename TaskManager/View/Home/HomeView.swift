//
//  ContentView.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//

import SwiftUI
import CoreData


struct HomeView: View {
    
    private enum FilterOption: Identifiable, Equatable {
        case all(Bool)
        case completed(Bool)
        case pending(Bool)
        
        var id: Bool {
            switch self {
            case .all:
                return true
            case .completed:
                return true
            case .pending:
                return false
            }
        }
    }
    
    private enum SortDirection: CaseIterable, Identifiable {
        case asc
        case desc
        
        var id: SortDirection {
            return self
        }
        
        var title: String {
            switch self {
            case .asc:
                return "Ascending"
            case .desc:
                return "Descending"
            }
        }
    }
    
    private enum SortOptions: String, CaseIterable, Identifiable {
        case priority = "priority"
        case date = "duedate"
        case alphabetically = "titles"
        
        var id: SortOptions {
            return self
        }
        
        var title: String {
            switch self {
            case .priority:
                return "priority"
            case .date:
                return "duedate"
            case .alphabetically:
                return "titles"
            }
        }
        
        var key: String {
            rawValue
        }
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.order, ascending: true)
        ]
    ) var items: FetchedResults<Item>
    
    
    @State private var showView = false
    @State private var openPage = false
    @State var menuOpened: Bool
    @State private var selectedFilterOption: FilterOption? = nil
    @State private var selectedSortDirection: SortDirection? = nil
    @State private var selectedSortOption: SortOptions? = nil
    @State private var setAZ = false
    @State private var setDate = false
    @State private var setPriority = true
    @State private var showSnackbar = false
    @State private var undoFlag = true
    @State private var itemCount: Int = 0
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    if items.isEmpty {
                        ContentUnavailableView("The early bird gets the worm", systemImage: "pencil.and.scribble")
                            .accessibilityElement()
                            .accessibilityLabel(Text("your task list is empty"))
                    } else {
                        ForEach(items) { item in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5)) {
                                NavigationLink {
                                    DetailView(hideButton: $showView, item: item)
                                        .scaleEffect(!showView ? 1.05 : 1.0)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: !showView)
                                    
                                } label: {
                                    TaskListCell(item:item)
                                        .shimmer(when: .constant(items.isEmpty))
                                        .accessibilityIdentifier("TaskItem_\(item)")
                                }
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .onMove(perform: moveItem)
                    }
                }
                .animation(.easeInOut, value: itemCount)
                .onChange(of: selectedFilterOption, performFilter)
                .navigationDestination(isPresented: $openPage) {
                    DetailSetView(hideButton: $showView)
                        .scaleEffect(openPage ? 1.05 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: openPage)
                }
                .navigationTitle("Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu(content: {
                            Button(action: {
                                selectedFilterOption = .all(true)
                            }, label: {Label("All", systemImage: "tray.2")})
                            .accessibilityElement()
                            .accessibilityLabel(Text("filter All"))
                            Button(action: {
                                selectedFilterOption = .completed(true)
                            }, label: {Label("Completed", systemImage: "tray.and.arrow.down.fill")})
                            .accessibilityElement()
                            .accessibilityLabel(Text("filter Completed"))
                            Button(action: {
                                selectedFilterOption = .pending(false)
                            }, label: {Label("Pending", systemImage: "tray.and.arrow.down")})
                            .accessibilityElement()
                            .accessibilityLabel(Text("filter Pending"))
                        }, label: {
                            Image(systemName: "circle.grid.3x3.fill")
                                .imageScale(.large)
                            
                        })
                        .accessibilityElement()
                        .accessibilityLabel(Text("filter button"))
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu(content: {
                            Button(action: {
                                selectedSortOption = .priority
                                selectedSortDirection = setPriority ? .asc : .desc
                                performSort()
                                setPriority.toggle()
                            }, label: {
                                Label(setPriority ? "Priority <-" : "Priority ->", systemImage: "arrowshape.left.arrowshape.right.fill")
                            })
                            .accessibilityElement()
                            .accessibilityLabel(Text("sort Priority"))
                            Button(action: {
                                selectedSortOption = .date
                                selectedSortDirection = setDate ? .desc : .asc
                                performSort()
                                setDate.toggle()
                            }, label: {Label(setDate ? "Date <-" : "Date ->", systemImage: "calendar.badge.clock")})
                            .accessibilityElement()
                            .accessibilityLabel(Text("sort Date"))
                            Button(action: {
                                selectedSortOption = .alphabetically
                                selectedSortDirection = setAZ ? .desc : .asc
                                performSort()
                                setAZ.toggle()
                            }, label: {Label(setAZ ? "Z-A":"A-Z", systemImage: "character.book.closed.fill")})
                            .accessibilityElement()
                            .accessibilityLabel(Text("sort alphabetically"))
                        }, label: {
                            Image(systemName: "square.and.arrow.down.on.square.fill")
                                .imageScale(.large)
                            
                        })
                        .accessibilityElement()
                        .accessibilityLabel(Text("sort button"))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            toggleMenu()
                        }) {
                            Image(systemName: "gear")
                        }
                        .accessibilityElement()
                        .accessibilityLabel(Text("setting button"))
                    }
                }
            }
            .foregroundStyle(Color.accentColor)
            
            VStack(alignment:.trailing) {
                Spacer()
                HStack {
                    Spacer()
                    PulseView(scannedText: "") { action in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5)) {
                            showView = true
                            openPage = true
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding()
                }
            }.isHidden(showView)
            
            SideMenu(width: UIScreen.main.bounds.width/1.6,
                     menuOpened: menuOpened,
                     toggleMenu: toggleMenu)
            .cornerRadius(22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .overlay(
            VStack {
                if showSnackbar {
                    Snackbar(message: "Stop deleting it!", actionText: "Undo") {
                        undoFlag = false
                        showSnackbar = false
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeInOut, value: showSnackbar)
                }
            }
                .padding(.bottom, 20),
            alignment: .bottom
        )
    }
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        Haptics.shared.notify(.success)
        Haptics.shared.play(.heavy)
        var reorderedItems = items.map { $0 }
        reorderedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in reorderedItems.enumerated() {
            item.order = Int16(index)
        }
        
        do {
            try viewContext.save()
            itemCount = items.count
        } catch {
            print("Failed to save order: \(error.localizedDescription)")
        }
    }
    
    func toggleMenu() {
        menuOpened.toggle()
    }
    
    private func deleteItems(offsets: IndexSet) {
        showSnackbar = true
        undoFlag = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showSnackbar = false
                if undoFlag {
                    undoFlag = false
                    withAnimation {
                        DispatchQueue.global(qos: .userInteractive).async {
                            offsets.map { items[$0] }.forEach(viewContext.delete)
                            do {
                                try viewContext.save()
                                itemCount = items.count
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func performSort() {
        
        guard let sortOption = selectedSortOption else { return }
        
        items.nsSortDescriptors = [NSSortDescriptor(key: sortOption.key, ascending: selectedSortDirection == .asc ? true : false)]
    }
    
    private func performFilter() {
        
        guard let selectedFilterOption = selectedFilterOption else { return }
        
        switch selectedFilterOption {
        case .all(let all):
            items.nsPredicate = NSPredicate(value: all)
            
        case .completed(let completed):
            items.nsPredicate = NSPredicate(format: "isdone == %@", NSNumber(value: completed))
            
        case .pending(let pending):
            items.nsPredicate = NSPredicate(format: "isdone == %@", NSNumber(value: pending))
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



#Preview {
    HomeView(menuOpened: false)
}

