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
            Spacer()
            if(vm.isSunrise)
            {
                Text("The sun rises at \(vm.currentCity?.sunrise ?? "") in:")
            } else{
                Text("The sun sets at \(vm.currentCity?.sunset ?? "") in:")
            }
            
            if (vm.currentCity != nil)
            {
                Text((vm.currentCity?.name ?? "") + ", " + (vm.currentCity?.country ?? ""))
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            Text("Your guess was \(vm.guessedTimeHourOffset ?? 0) hours and \(vm.guessedTimeMinuteOffset ?? 0) minutes off")
            
            Spacer()
           
                Button("Play Again") {
                    self.isShown = false
                    self.onPlayagain()
            }
            Spacer()
            
        }
        .padding()
        .frame(width: screenSize.width * 0.8, height: screenSize.height * 0.4)
        .background(Color.white)
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
