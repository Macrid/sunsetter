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
    @State var isSunrise = Bool.random()
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        VStack
        {
            if(isSunrise)
            {
                Text("When does the sun rise in:")
            } else{
                Text("When does the sun set in:")
            }
            

            
            Text((vm.currentCity?.name ?? "") + ", " + (vm.currentCity?.country ?? ""))
                .font(.largeTitle)
                .padding()
                .animation(.easeIn(duration: 1))
                
            
            DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

            Button(action: {
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                var pickedTime = df.string(from: currentTime)
                
            }, label: {
                Text("Bam")
            })
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

