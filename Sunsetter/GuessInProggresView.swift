//
//  guessInProggresView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-06.
//

import SwiftUI
/*
struct GuessInProggresView: View {
    
    @State var isSunrise = Bool.random()
    @State var stad = ""
    
    @State var currentTime = Date()
    
    @State var guessedTimeHourOffset:Int?
    @State var guessedTimeMinuteOffset:Int?
    
    @State var sunriseUTCTime:String?
    @State var sunriselocalTime:String?
    @State var sunsetUTCTime:String?
    @State var sunsetlocalTime:String?
    
    var body: some View {
        VStack
        {
            if(isSunrise)
            {
                Text("When does the sun rise in:")
            } else{
                Text("When does the sun set in:")
            }
            Text("\(stad)")
                .font(.largeTitle)
                .padding()
            DatePicker("", selection: $currentTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
            Button(action: {
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                var pickedTime = df.string(from: currentTime)
                
                (guessedTimeHourOffset, guessedTimeMinuteOffset) = compareTime(guessedTime: pickedTime, actualTime: sunsetlocalTime!)
                
            }, label: {
                Text("Bam")
            })
        }
        
    }
}

struct guessInProggresView_Previews: PreviewProvider {
    static var previews: some View {
        guessInProggresView()
            .previewLayout(.sizeThatFits)
    }
}
*/
