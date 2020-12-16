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
    
    var body: some View {
        ZStack{
            VStack
            {
                Adview()
                    .frame(width: UIScreen.main.bounds.width, height: 60)
                
                if(vm.isSunrise)
                {
                    Text("When does the sun rise in:").padding(.top)
                } else{
                    Text("When does the sun set in:").padding(.top)
                }
                
                
                if (vm.loadInProgress == false)
                {
                    Text((vm.currentCity?.name ?? "") + ", " + (vm.currentCity?.country ?? ""))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                
                DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                
                if (vm.loadInProgress == false)
                {
                    Button(action: {
                        vm.getResult(guessedTime: currentTime)
                        isGameEnded = true
                    }, label: {
                        Text("Bam")
                    }).padding(.top, 20.0)
                }
                Spacer()
            }.background(HalfCircleView())
            AfterGameView(isShown: $isGameEnded, onPlayagain: vm.getRandomCity)
        }
    }
    
}


struct guessInProggresView_Previews: PreviewProvider {
    static var previews: some View {
        GuessInProgressView()
    }
}

