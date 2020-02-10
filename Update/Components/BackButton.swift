//
//  BackButton.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct BackButton: View {
    let label: String
    let closure: () -> ()

    var body: some View {
        Button(action: { self.closure() }) {
            HStack {
                Image(systemName: "chevron.left")
                Text(label)
            }
        }
    }
}
