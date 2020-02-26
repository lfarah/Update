//
//  PostList.swift
//  Update
//
//  Created by Lucas Farah on 2/9/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine
import FeedKit

struct PostList: View {
    @ObservedObject var viewModel: PostListViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var tappedClose: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.backgroundNeo
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)

            List {
                FilterView(selectedFilter: $viewModel.filterType, showFilter: $viewModel.showFilter, markedAllPostsRead: {
                    self.viewModel.markAllPostsRead()
                }).listRowBackground(Color.backgroundNeo)
                
                ForEach(viewModel.filteredPosts.indices, id: \.self) { index in
                    Button(action: {
                        self.viewModel.selectPost(index: index)
                    })  {
                        PostCell(post: self.viewModel.filteredPosts[index])
                    }.listRowBackground(Color.backgroundNeo)
                }
            }
            .background(Color.clear)
            .padding(.top, 60)
            .sheet(isPresented: self.$viewModel.showingDetail) {
                SafariView(url: self.viewModel.selectedPost!.url)
            }
            
            NavBar(title: "Latest posts",
                   hideType: tappedClose != nil ? .close : .back,
                   updatePosts: updatePosts,
                   goBack: goBack,
                   close: tappedClose,
                   showNewFeedPopup: .constant(false),
                   showFilter: $viewModel.showFilter,
                   buttons: [.filter, .reload])
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func updatePosts() {
        viewModel.reloadPosts()
    }
}

#if DEBUG
struct PostList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            NavigationView {
                PostList(viewModel: PostListViewModel(feed: FeedObject.testObject))
            }
            
            NavigationView {
                PostList(viewModel: PostListViewModel(feed: FeedObject.testObject))
            }.environment(\.colorScheme, .light)
        }
    }
}
#endif
