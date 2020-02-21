//
//  OnboardingLoadingCloud.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct OnboardingLoadingCloud: View {
    @Binding var show: Bool

    var body: some View {
        ZStack {
            UpperLoadingCloud(show: $show)
            LowerLoadingCloud(show: $show)
        }
    }
}

struct UpperLoadingCloud: View {
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 30))
                .animation(.easeInOut)
                .offset(x: show ? -500 : -100, y: show ? -500 : -200)
                .animation(.easeInOut)
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 60))
                .animation(.easeInOut)
                .offset(x: show ? -170 : -150, y: show ? -500 : -350)
                .animation(.easeInOut)
            
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 0))
                .animation(.easeInOut)
                .offset(x: show ? 500 : 100, y: show ? -500 : -300)
                .animation(.easeInOut)
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 450))
                .animation(.easeInOut)
                .offset(x: show ? 500 : 120, y: show ? -500 : -150)
                .animation(.easeInOut)
            
        }
    }
}

struct LowerLoadingCloud: View {
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 30))
                .animation(.easeInOut)
                .offset(x: show ? -500 : -100, y: show ? 500 : 200)
                .animation(.easeInOut)
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 30))
                .offset(x: show ? -500 : -140, y: show ? 500 : 400)
                .animation(.easeInOut)
            
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 50))
                .rotationEffect(Angle.degrees(show ? 900 : 30))
                .animation(.easeInOut)
                .offset(x: show ? 500 : 140, y: show ? 200 : 300)
                .animation(.easeInOut)
        }
    }
}

struct OnboardingLoadingCloud_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingLoadingCloud(show: .constant(true))
    }
}
