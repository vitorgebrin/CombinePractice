//
//  BookDetailedView.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 15/09/24.
//

import SwiftUI
import SwiftData

struct BookDetailedView: View {
    @Environment (\.modelContext) private var modelContext
    @Query(sort: \Book.title) var books:[Book]
    @State var favorite:Bool = false
    var book:Book
    var body: some View {
        Text(book.title)
            .font(.title)
        
        AsyncImage(url:URL(string:"https://covers.openlibrary.org/b/id/\(book.cover_i).jpg")){ image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 200).clipShape(RoundedRectangle(cornerRadius: 10))
        } placeholder: {
            ProgressView()
        }.frame(width: 200)
        VStack(alignment: .leading){
            Text("First Sentence:")
                .font(.title3)
                .padding(.horizontal)
                .padding(.top,20)
                
            Text(book.first_sentence[0])
                .foregroundStyle(.gray)
                .padding(.horizontal)
                .padding(.vertical,10)
            
            Text("Author:")
                .font(.title3)
                .padding(.horizontal)
                .padding(.top,20)
            Text(book.author_name[0])
                .foregroundStyle(.gray)
                .padding(.horizontal)
                .padding(.top,5)
            
            Text("Check on Amazon:")
                .font(.title3)
                .padding(.horizontal)
                .padding(.top,20)
            
            Link(destination: URL(string: "https://amazon.com/dp/\(book.id_amazon[0])")!){
                Text("Open book on Amazon")
        
                    .padding(.horizontal)
                    .padding(.top,5)
            }
            
            Button(favorite ? "Already on My books" : "Add to My books" ){
                if !favorite{
                    modelContext.insert(book)}
                favorite.toggle()
            }
        }.onAppear(perform: {checkIfAdded()})
        
    }
    
    func checkIfAdded(){
        if let index = books.firstIndex(where: { $0.title == book.title }) {
            self.favorite.toggle()
        }
    }
}

#Preview {
    BookDetailedView(book: Book(author_name: ["J.R.R. Tolkien"], title: "The Lord of the Rings", cover_i: 14625765, first_sentence: ["In a hole in the ground there lived a hobbit. Not a nasty diry wet hole, filled with ends of worms and an oozy smell..."], id_amazon: ["B004EZ4I3C"]))
}
