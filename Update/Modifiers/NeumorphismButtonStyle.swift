//
//  NeumorphismButtonStyle.swift
//  Update
//
//  Created by Lucas Farah on 2/15/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

extension Color {
    static let mainColor = Color(red: 224/255, green: 229/255, blue: 236/255)
    static let mainColorActive = Color(red: 220/255, green: 225/255, blue: 232/255)
    static let grayIcon = Color(red: 143/255, green: 157/255, blue: 188/255)
    static let grayActiveIcon = Color(red: 120/255, green: 140/255, blue: 160/255)
}
struct NeumorphismButtonStyle: ButtonStyle {
    var value: CGFloat
    var radius: CGFloat = 15
    
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .foregroundColor(.white)
        .colorMultiply(configuration.isPressed ? Color.grayActiveIcon : .backgroundNeo)
        .background(configuration.isPressed ? Color.mainColorActive : .backgroundNeo)
        .cornerRadius(self.radius)
        .modifier(configuration.isPressed ? NeumorphismShadow.none : .simple(value: self.value))
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        // I didn't like the original animation luckily it can be changed this easily!
        .animation(.easeOut(duration: 0.1))
  }
}
