//
//  BeforeStartView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-07.
//

import SwiftUI

struct BeforeStartView: View {
    @ObservedObject var vm: ContentViewModel = .shared
    @State var isShowingGuessInProgressView = false
    @State var appeared: Double = 0
    
    var body: some View {
        if (isShowingGuessInProgressView)
        {
            VStack{
                GuessInProgressView()
            }
            .opacity(appeared)
            .animation(.easeInOut(duration: 2), value: appeared)
            .onAppear {self.appeared = 1.0}
            .onDisappear {self.appeared = 0.0}
        }else{
            VStack{
                Spacer()
                Button(action: {
                    self.isShowingGuessInProgressView = true
                    vm.getRandomCity()
                }, label: {
                    Text("START")
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                })
                .frame(width: 150, height: 50)
                .background(Color.init(hex:0x5F0F40))
                .cornerRadius(15)
                .padding(.top, 20.0)
                HStack {
                    Spacer()
                    Text("Correct guesses: \(vm.points!)")
                        .frame(width: 175, height: 40)
                        .background(Color.white)
                        .foregroundColor(Color.init(hex:0x5F0F40))
                        .cornerRadius(15)
                        .padding()
                    Spacer()
                }
                
                Spacer()
            }
            .background(Image("citysunset2")
                            .resizable()
                            .scaledToFill()
                            .clipped())
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BeforeStartView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeStartView()
    }
}
