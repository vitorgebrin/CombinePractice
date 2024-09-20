//
//  MyBooksView.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 18/09/24.
//

import SwiftUI
import SwiftData

struct MyBooksView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Book.title) var books:[Book]
    @State var searchForBook:Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(books){ book in
                        NavigationLink{BookDetailedView(book: book)} label: {BookCard(book: book)}
                        
                    }.onDelete(perform: { indexSet in
                        indexSet.forEach{ index in
                            let book = books[index]
                            modelContext.delete(book)
                        }
                    })}
            }.navigationTitle("My Books")
            .toolbar {
                Button{
                    searchForBook.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }.sheet(isPresented: $searchForBook) {
                    BooksView()
                }
            }
        }
    }
}

#Preview {
    MyBooksView().modelContainer(for: Book.self,inMemory: true)
}
