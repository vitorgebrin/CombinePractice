//
//  MyBooksView.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 18/09/24.
//

import SwiftUI

struct MyBooksView: View {
    @State var searchForBook:Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
    MyBooksView()
}
