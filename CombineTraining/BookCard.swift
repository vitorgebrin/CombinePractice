//
//  BookCard.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 10/09/24.
//

import SwiftUI

struct BookCard: View {
    let coverUrl:String
    let title:String
    let author:String
    let previewText:String
    var body: some View {
        HStack(alignment:.top){
            AsyncImage(url:URL(string:coverUrl)){ image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60).clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
            }.frame(width: 80)
            VStack(alignment: .leading){
                Text(title)
                    .font(.title2)
                
                Text("by: \(author)")
                    .font(.caption)
                    .padding(.leading,5)
                    .padding(.bottom,10)

                Text(previewText)
                    .font(.caption2).foregroundStyle(.gray)
                    .padding(.leading,5)

            }
            .padding(.leading,10)
            .padding(.trailing,10)
            .padding(.top,0)
            
                
        }.frame(height: 140)
        .background(in:RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
        .backgroundStyle(Color(uiColor: .systemGray6))
        
    }
}

#Preview {
    BookCard(coverUrl: "https://covers.openlibrary.org/b/id/14625765.jpg", title: "The Lord of the Rings", author: "J.R.R. Tolkien", previewText: "In a hole in the ground there lived a hobbit. Not a nasty diry wet hole, filled with ends of worms and an oozy smell...")
}
