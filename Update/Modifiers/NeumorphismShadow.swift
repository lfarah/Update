//
//  NeumorphismShadow.swift
//  Update
//
//  Created by Lucas Farah on 2/15/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

extension Color {
    static let grayShadow = Color(red: 163/255, green: 177/255, blue: 198/255)
}

// https://gist.github.com/Julioacarrettoni/20987de19f2d64788f9636278ea27707
struct NeumorphismShadow: ViewModifier {
    var top: Color = Color.shadowBottomNeo
    var bottom: Color = Color.shadowTopNeo
    
    /// This is at the same time the radius and the offsets of the shadows is just here so we are able to play with the slider
    var value: CGFloat = 5
    
    func body(content: Content) -> some View {
        content
            .overlay(Color.clear)
            .shadow(color: self.top, radius: value, x: value, y: value)
            .shadow(color: self.bottom, radius: value, x: -value, y: -value)
    }
    
    static var none = NeumorphismShadow(top: .grayShadow, bottom: .white, value: 0)
    static func simple(value: CGFloat) -> NeumorphismShadow {
        NeumorphismShadow(top: .grayShadow, bottom: .white, value: value)
    }
}
