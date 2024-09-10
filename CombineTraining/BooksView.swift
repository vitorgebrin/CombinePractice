//
//  ContentView.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 06/09/24.
//

import SwiftUI
import SwiftData
import Combine

class BooksViewModel: ObservableObject {
    @Published var books:[Book] = []
    @Published var hasErrors = false
    @Published var error: BookError?
    @Published private(set) var isLoading = false
    var cancellables = Set<AnyCancellable>()
    
    func fetchBooks() -> () {
        let bookUrlString = "https://openlibrary.org/search.json?q=the+lord+of+the+rings&sort=currently_reading&limit=4&lang=en"
        if let url = URL(string: bookUrlString) {
            URLSession.shared
                .dataTaskPublisher(for: url)
                .receive(on: DispatchQueue.main)
                .map(\.data).decode(type: BookJson.self, decoder: JSONDecoder())
                .sink{ resposta in
                    switch resposta{
                    case .failure(let error):
                        print("oops")
                        print(error.localizedDescription)
                    default:
                        break
                    }
                } receiveValue: { [weak self] bookJson in
                    self?.books = bookJson.docs
                }.store(in: &cancellables)
            
        }
    }
    
    enum BookError {
        case custom(error:Error)
        case failedToDecode
    }
}

struct BooksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject var vm = BooksViewModel()

    var body: some View {
        NavigationSplitView {
            if !vm.books.isEmpty{
                ScrollView{
                    ForEach(vm.books,id: \.id_amazon){ book in
                    
                        BookCard(coverUrl: "https://covers.openlibrary.org/b/id/\(book.cover_i).jpg", title: book.title, author: book.author_name[0], previewText: book.first_sentence[0])
                    }}
                } else {ProgressView()}
            
        } detail: {
            Text("Find Book")
        }.onAppear(perform:{
            vm.fetchBooks()
        })
    }
}

#Preview {
    BooksView()
        .modelContainer(for: Item.self, inMemory: true)
}
