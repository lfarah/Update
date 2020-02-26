//
//  SettingsView.swift
//  Update
//
//  Created by Lucas Farah on 2/15/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Binding var fetchContentTime: String
    @Binding var notificationsEnabled: Bool
    @Binding var shouldOpenSettings: Bool
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    Form {
                        Picker(selection: $fetchContentTime, label: Text("Fetch content time")) {
                            ForEach(ContentTimeType.allCases, id: \.self.rawValue) { type in
                                Text(type.rawValue)
                            }
                        }
                        Toggle(isOn: $notificationsEnabled) {
                            Text("Enable Notifications")
                        }
                    }
                }
                .navigationBarTitle(Text("Settings"))
                .navigationBarItems(leading:
                    Button(action: {
                        self.shouldOpenSettings = false
                    }, label: {
                        Text("Close")
                    }
                    )
                )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(fetchContentTime: .constant("minute1"), notificationsEnabled: .constant(false), shouldOpenSettings: .constant(true))
    }
}
