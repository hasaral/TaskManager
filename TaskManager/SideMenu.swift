//
//  SideMenu.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//
import SwiftUI
import Foundation

struct SideMenu: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            // Dimmed background view
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.15))
            .opacity(self.menuOpened ? 1 : 0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.toggleMenu()
            }
            
            // MenuContent
            HStack {
                MenuContent()
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default)
                
                Spacer()
            }
        }
    }
}

struct MenuItem: Identifiable {
    var id = UUID()
    let text: String
    let imageName: String
    let handler: () -> Void = {
        print("Tapped item")
    }
}

struct MenuContent: View {
    let items: [MenuItem] = [
        MenuItem(text: "Settings", imageName: "gear"),
    ]
    
    @State var backgroundColor = Color(UIColor(red: 43/255.0,
                                               green: 40/255.0,
                                               blue: 74/255.0, alpha: 0.5))
    
    @AppStorage("colorkey") var storedColor: Color = .accentColor
    @AppStorage("appTheme") private var isDarkModeOn = false
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack(alignment: .leading, spacing: 0) {
                
                Divider()
                
                VStack {
                    ColorPicker("Set a custom color", selection: $backgroundColor, supportsOpacity: true)
                        .accessibilityElement()
                        .accessibilityLabel(Text("Set a custom color"))
                    Toggle(isDarkModeOn ? "Light" : "Dark",isOn: $isDarkModeOn)
                        .toggleStyle(.switch)
                        .tint(.orange)
                        .foregroundColor(.blue)
                        .padding(.top, 30)
                        .accessibilityElement()
                        .accessibilityLabel(Text("Dark mode setting"))
                }.onChange(of: backgroundColor, perform: { value in
                    storedColor = value
                })
                
                .padding(.top, 30)
                .padding()
                Spacer()
                
            }
            .frame(maxHeight: .infinity)
            //.padding(.top, 25)
        }
        .frame(maxHeight: .infinity)
    }
}
