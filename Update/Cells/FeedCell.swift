//
//  FeedCell.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedCell: View {
    @ObservedObject var feed: FeedObject
    
    var body: some View {
        HStack {

            WebImage(url: feed.imageURL)
                .renderingMode(.original)
                .resizable()
                .placeholder {
                    Rectangle().foregroundColor(.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.leading)
                
            VStack(alignment: .leading) {
                Text(feed.name)
                    .font(.subheadline)
                    .foregroundColor(Color(.label))
                
                Text("\(feed.posts.filter { !$0.isRead }.count) unread posts")
                    .font(.footnote)
                .foregroundColor(.gray)

            }

            Spacer()
        }

    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(feed: FeedObject(name: "Test feed", url: URL(string: "https://www.google.com")!, posts: [Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!)]))
    }
}
