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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        ZStack{
            VStack
            {
                //                HStack{
                //                    Text("Correct guesses: \(vm.points!)")
                //                        .frame(width: 175, height: 40)
                //                        .background(Color.white)
                //                        .foregroundColor(Color.init(hex:0x5F0F40))
                //                        .cornerRadius(15)
                //                        .padding()
                //                    Spacer()
                //                }
                if (UIScreen.main.bounds.height >= 800)
                {
                    Spacer()
                }
                if(vm.isSunrise)
                {
                    Text("When does the sun rise in:").padding(.top, 50.0)
                } else{
                    Text("When does the sun set in:").padding(.top, 50.0)
                }
                
                
                if (vm.loadInProgress == false)
                {
                    Text((vm.currentCity?.name ?? "") + ", " + (vm.currentCity?.country ?? ""))
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }else{
                    ProgressView()
                        .frame(width: 50, height: 50)
                        .scaledToFill()
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
                        Text("GUESS")
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    })
                    
                    .frame(width: 150, height: 50)
                    .background(Color.init(hex:0x5F0F40))
                    .cornerRadius(15)
                    .padding(.top, 20.0)
                    //.shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    
                    
                }
                Spacer()
            }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(HalfCircleView())
            
            /*
            VStack
            {
                HStack{
                    Text("Correct guesses: \(vm.points!)")
                        .frame(width: 175, height: 40)
                        .background(Color.white)
                        .foregroundColor(Color.init(hex:0x5F0F40))
                        .cornerRadius(15)
                        .padding([.top], 30.0)
                        .padding(.leading, 20.0)
                    Spacer()
                }
                Spacer()
            }*/
            
            AfterGameView(isShown: $isGameEnded, onPlayagain: vm.getRandomCity)
        }
    }
    
}


struct guessInProggresView_Previews: PreviewProvider {
    static var previews: some View {
        GuessInProgressView()
    }
}

