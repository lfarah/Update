//
//  FeedEmptyRow.swift
//  Update
//
//  Created by Lucas Farah on 2/20/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct FeedEmptyRow: View {
    var body: some View {
        VStack {
            Image("OnboardingAppIcon")
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Text("Welcome!")
                .font(.title)
            
            Text("Tap + to add your first feed")
                .font(.subheadline)
        }
    }
}

struct FeedEmptyRow_Previews: PreviewProvider {
    static var previews: some View {
        FeedEmptyRow()
    }
}
