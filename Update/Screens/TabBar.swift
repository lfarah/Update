//
//  TabBar.swift
//  Update
//
//  Created by Lucas Farah on 2/12/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var store = RSSStore.instance
    var feedListViewModel = FeedListViewModel()
    var goalsViewModel = GoalsViewModel()

    var body: some View {
        TabView {
            FeedList(viewModel: feedListViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feeds")
                }

            GoalsView(viewModel: goalsViewModel)
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Progress")
                }

            #if !targetEnvironment(macCatalyst)
                SettingsView(fetchContentTime: self.$store.fetchContentTime, notificationsEnabled: self.$store.notificationsEnabled, shouldOpenSettings: self.$store.shouldOpenSettings)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                }
            #endif
            
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
