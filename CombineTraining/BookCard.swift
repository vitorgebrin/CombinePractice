//
//  BookCard.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 10/09/24.
//

import SwiftUI


struct BookCard: View {
    let book:Book
    var body: some View {
        
        HStack(alignment:.top){
            VStack{
                if let image = book.image {
                    Image(uiImage: (UIImage(data: image) ?? UIImage(systemName: "plus")!))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else{ProgressView()
                }
            }.frame(width:80)
            VStack(alignment: .leading){
                Text(book.title)
                    .font(.title3)
                    .foregroundStyle(.black)
                
                Text("by: \(book.author_name[0])")
                    .font(.caption)
                    .foregroundStyle(.black)
                    .padding(.leading,5)
                    .padding(.bottom,10)

                Text(book.first_sentence[0])
                    .font(.caption2).foregroundStyle(.gray)
                    .padding(.leading,5)

            }
            .padding(.leading,0)
            .padding(.trailing,10)
            .padding(.top,0)
            Spacer()
                
        }.padding().frame(maxWidth:.infinity,maxHeight: 160)
        .background(in:RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
        .backgroundStyle(Color(uiColor: .systemGray6))
        
    }
}

#Preview {
    BookCard(book: Book(author_name: ["J.R.R. Tolkien"], title: "The Lord of the Rings", cover_i: 14625765, first_sentence: ["n a hole in the ground there lived a hobbit. Not a nasty diry wet hole, filled with ends of worms and an oozy smell..."], id_amazon: ["String"]))
}
