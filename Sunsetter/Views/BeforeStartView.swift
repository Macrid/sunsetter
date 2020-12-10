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
    
    init() {
        UINavigationBar.setAnimationsEnabled(false)
    }
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(
                    destination: GuessInProgressView(),
                    isActive: $isShowingGuessInProgressView) { EmptyView() }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                Button("Start") {
                    vm.getRandomCity()
                    self.isShowingGuessInProgressView = true
                }
            }
        }.transition(.opacity)
    }
}

struct BeforeStartView_Previews: PreviewProvider {
    static var previews: some View {
        BeforeStartView()
    }
}
