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
            if (isShowingGuessInProgressView)
            {
                VStack{
                    GuessInProgressView()
                }
                .opacity(appeared)
                .animation(.easeInOut(duration: 2), value: appeared)
                .onAppear {self.appeared = 1.0}
                .onDisappear {self.appeared = 0.0}
            }
            /* NavigationLink(
             destination: GuessInProgressView(),
             isActive: $isShowingGuessInProgressView) { EmptyView() }
             .navigationBarTitle("")
             .navigationBarHidden(true)*/
            else{
                Button("Start") {
                    self.isShowingGuessInProgressView = true
                    vm.getRandomCity()
                }
            }
        }
    }
}

struct BeforeStartView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeStartView()
    }
}
