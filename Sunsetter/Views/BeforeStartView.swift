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
        VStack{
            Spacer()
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
                /* NavigationLink(
                 destination: GuessInProgressView(),
                 isActive: $isShowingGuessInProgressView) { EmptyView() }
                 .navigationBarTitle("")
                 .navigationBarHidden(true)*/
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
               // .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            }
            Text("Correct guesses: \(vm.points!)")
                .frame(width: 175, height: 40)
                .background(Color.white)
                .foregroundColor(Color.init(hex:0x5F0F40))
                .cornerRadius(15)
                .padding()
            Spacer()
           /* HStack {
                Text("Correct guesses: \(vm.points!)")
                    .frame(width: 175, height: 50)
                    //.background(Color.init(hex:0x5F0F40))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }*/
            
        }
        .background(Image("citysunset2")
                        .resizable()
                        //.blur(radius: 1)
                        .scaledToFill()
                        .clipped())
        .edgesIgnoringSafeArea(.all)
        
        
    }
}

struct BeforeStartView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeStartView()
    }
}
