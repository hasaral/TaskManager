//
//  PulseView.swift
//  TaskManager
//
//  Created by Hasan Saral on 11.03.2025.
//


import SwiftUI


struct PulseView: View {
    @State var startAnimation = false
    @State var pulse1 = false
    @State var pulse2 = false
    @State var pulse3 = false
    @State var pulse4 = false
    @State var finishAnimation = false
    @State var greenAnimation = true
    
    var scannedText: String
    let actionHandler: (_ action: Bool) -> Void
    @State var touchAct = false
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(greenAnimation ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 2)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulse1 ? 2.3 : 0)
                    .opacity(pulse1 ? 0 : 1)
                
                Circle()
                    .stroke(greenAnimation ? Color.green.opacity(0.6) : Color.red.opacity(0.6), lineWidth: 4)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulse2 ? 1.3 : 0)
                    .opacity(pulse2 ? 0 : 1)
                
                Circle()
                    .stroke(greenAnimation ? Color.green.opacity(0.9) : Color.red.opacity(0.9), lineWidth: 6)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulse3 ? 1.3 : 0)
                    .opacity(pulse3 ? 0 : 1)
                
                Circle()
                    .stroke(greenAnimation ? Color.green.opacity(1) : Color.red.opacity(1), lineWidth: 8)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulse4 ? 1.3 : 0)
                    .opacity(pulse4 ? 0 : 1)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 90, height: 90)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: 5, y: 5)
                
                ZStack {
                    Circle()
                        .stroke(Color.green, lineWidth: greenAnimation ? 4 : 1.4)
                        .frame(width:60, height: 60)
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color.green)
                    
                }
                .frame(width: 70, height: 70)
                .onTapGesture {
                    if !touchAct {
                        touchAct = false
                        verifyAndAddPeople()
                        actionHandler(true)
                    }
                }
                
            }
            .frame(maxHeight: .infinity)
            
        }
        .accessibility(addTraits: .isButton)
        .accessibilityIdentifier("OpenTaskButton")
        .ignoresSafeArea()
        .background(Color.clear.opacity(0.05).ignoresSafeArea())
        .onAppear {
            animateView()
        }
    }
    
    func animateView() {
        startAnimation.toggle()
        
        withAnimation(Animation.linear(duration: 3).delay(-0.1).repeatForever(autoreverses: false)){
            pulse1.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.linear(duration: 6).delay(-0.1).repeatForever(autoreverses: false)){
                pulse2.toggle()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(Animation.linear(duration: 9).delay(-0.1).repeatForever(autoreverses: false)){
                pulse3.toggle()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(Animation.linear(duration: 11).delay(-0.1).repeatForever(autoreverses: false)){
                pulse4.toggle()
            }
        }
    }
    
    func verifyAndAddPeople() {
        withAnimation(Animation.linear(duration: 0.6)) {
            finishAnimation.toggle()
            startAnimation = false
            pulse1 = false
            pulse2 = false
            pulse3 = false
            pulse4 = false
        }
    }
}


extension View {
    func getSafeArea()->UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func getRect()->CGRect{
        return UIScreen.main.bounds
    }
}



var firstFiveOffsets: [CGSize] = [
    CGSize(width: 100, height: 100),
    CGSize(width: -100, height: -100),
    CGSize(width: -50, height: 130),
    CGSize(width: 50, height: -130),
    CGSize(width: 120, height: -50),
]
