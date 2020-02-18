//
//  RingGraphView.swift
//  Update
//
//  Created by Lucas Farah on 2/17/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct RingGraphView: View {
    @Binding var show: Bool
    @State var goalPercentage: CGFloat
    
    var width: CGFloat = 100
    var height: CGFloat = 100
    
    var color = #colorLiteral(red: 0.1527788341, green: 0.7198211551, blue: 0.3009665906, alpha: 1)
    
    var body: some View {
        let multiplier = width / 44
        let progress = 1 - (goalPercentage / 100)
        
        return ZStack {
            Circle()
                .stroke(Color("ShadowBottomNeo").opacity(0.5), style: StrokeStyle(lineWidth: 5 * multiplier))
                .frame(width: width, height: height)
            
            
            Circle()
                .trim(from: show ? progress : 1, to: 1)
                .stroke(
                    Color(color),
                    style: StrokeStyle(lineWidth: 2 * multiplier, lineCap: .round, lineJoin: .round, miterLimit: .infinity, dash: [20, 0], dashPhase: 0)
                )
                .animation(Animation.easeIn.delay(0.5))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .foregroundColor(.orange)
                .frame(width: width * 0.95, height: height * 0.95)
                .shadow(color: Color(color), radius: 10, x: 0, y: 0)
                .modifier(NeumorphismShadow())
            
            Text("\(Int(goalPercentage))%")
                .font(.system(size: 12 * multiplier))
                .fontWeight(.regular)
                .foregroundColor(Color.gray)
        }
    }
}
struct RingGraphView_Previews: PreviewProvider {
    static var previews: some View {
        RingGraphView(show: .constant(true), goalPercentage: 70)
    }
}
