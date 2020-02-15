//
//  PostCell.swift
//  Update
//
//  Created by Lucas Farah on 2/10/20.
//  Copyright © 2020 Lucas Farah. All rights reserved.
//

import SwiftUI
import Combine

struct PostCell: View {
    @ObservedObject var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(post.title)
                .font(.headline)
                .foregroundColor(Color(.label))
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(Color(.label))
            
            HStack {
                Text(formatDate(with: post.date))
                    .frame(height: 15)
                    .font(.footnote)
                    .padding(.all, 8)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                Image(systemName: "eye")
                    .frame(height: 15)
                    .foregroundColor(.white)
                    .padding(.all, 8)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(post.isRead ? 1 : 0)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 100)
        .padding(.trailing)
        .background(Color("BackgroundNeo"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: Color("ShadowTopNeo"), radius: 5, x: -4, y: -4)
        .shadow(color: Color("ShadowBottomNeo"), radius: 5, x: 4, y: 4)
    }
    
    func formatDate(with date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today at " + date.toString(format: "HH:mm a")
        } else {
            return date.toString(format: "dd/MM/yyyy")
        }
    }
}

struct PostCell_Previews: PreviewProvider {
    static var previews: some View {
        PostCell(post: Post(title: "Test post title", description: "Test post description", url: URL(string: "https://www.google.com")!))
    }
}
