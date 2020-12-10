//
//  guessInProggresView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-06.
//

import SwiftUI

struct GuessInProgressView: View {
    @State var currentTime = Date()
    @ObservedObject var vm: ContentViewModel = .shared
    @State var isGameEnded = false
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        ZStack{
            VStack
            {
                if(vm.isSunrise)
                {
                    Text("When does the sun rise in:")
                } else{
                    Text("When does the sun set in:")
                }
                
                
                if (vm.currentCity != nil)
                {
                    Text((vm.currentCity?.name ?? "") + ", " + (vm.currentCity?.country ?? ""))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                       //.animation(.easeIn(duration: 1))
                }
                
                
                DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                
                Button(action: {
                    vm.getResult(guessedTime: currentTime)
                    isGameEnded = true
                }, label: {
                    Text("Bam")
                })
            }.animation(.easeIn(duration: 1))
            AfterGameView(isShown: $isGameEnded)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct guessInProggresView_Previews: PreviewProvider {
    static var previews: some View {
        GuessInProgressView()
    }
}

