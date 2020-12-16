//
//  AfterGameView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-07.
//

import SwiftUI

struct AfterGameView: View {
    @ObservedObject var vm: ContentViewModel = .shared
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    var onPlayagain: () -> Void = { }
    
    var body: some View {
        VStack(spacing: 20){
            if(vm.isSunrise)
            {
                //Text("In \n\(vm.currentCity?.name ?? ""), \n\(vm.currentCity?.country ?? "")\nthe sun rises at:\n\(vm.currentCity?.sunrise ?? "")")
                Text("In")
                Text("\(vm.currentCity?.name ?? ""),")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text(vm.currentCity?.country ?? "")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    
                Text("the sun rises at:")
                Text(vm.currentCity?.sunrise ?? "")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                //Text("The sun rises at \(vm.currentCity?.sunrise ?? "") in:")
            } else{
                Text("In")
                Text(vm.currentCity?.name ?? "")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text(vm.currentCity?.country ?? "")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text("the sun sets at:")
                Text(vm.currentCity?.sunset ?? "")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                //Text("The sun sets at \(vm.currentCity?.sunset ?? "") in:")
            }
            if(vm.guessedTimeHourOffset == 0 && vm.guessedTimeMinuteOffset == 0)
            {
                Text("Wow, you got it exactly right!")
                    .multilineTextAlignment(.center)
            }
            else{
                Text("Your guess was \(vm.guessedTimeHourOffset ?? 0) hours and \(vm.guessedTimeMinuteOffset ?? 0) minutes off")
                    .multilineTextAlignment(.center)
            }
                Button("Play Again") {
                    self.isShown = false
                    self.onPlayagain()
                }.padding()
            
        }
        .padding()
        .frame(width: screenSize.width * 0.8)
        .background(Color.init(hex: 0xeae2b7))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color.black ,radius: 15, x: 0, y: 0)
        
    }
}


struct AfterGameView_Previews: PreviewProvider {
    static var previews: some View {
        AfterGameView(isShown: .constant(true))
    }
}

