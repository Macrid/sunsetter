//
//  HalfCircleView.swift
//  Sunsetter
//
//  Created by Erik Persson on 2020-12-14.
//

import SwiftUI

struct HalfCircleView: View {
    static let gradientStart = Color.init(hex: 0xE36414)
    static let gradientEnd = Color.init(hex: 0x9A031E )
    
    var body: some View {
        
        VStack{
            Spacer()
            Circle()
                .trim(from: 0.5, to: 1)
                .fill(LinearGradient(
                    gradient: .init(colors: [Self.gradientStart,
                                             Self.gradientEnd]),
                    startPoint: .init(x: 0.5, y: 0.35),
                    endPoint: .init(x: 0.5, y: 0.6)
                ))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        }
    }
    
}


struct HalfCircleView_Previews: PreviewProvider {
    static var previews: some View {
        HalfCircleView()
            .previewLayout(.sizeThatFits)
    }
}
