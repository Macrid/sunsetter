//
//  ContentViewNew.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-07.
//

import SwiftUI

struct ContentViewNew: View {
    @ObservedObject var vm: ContentViewModel = .shared
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContentViewNew_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewNew()
    }
}
