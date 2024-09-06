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
    var cancellables:Set<AnyCancellable> = []
    
    func fetchBooks() -> () {
        let bookUrlString = "https://openlibrary.org/search.json?q=the+lord+of+the+rings&sort=currently_reading&limit=3&lang=en"
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
                        AsyncImage(url:URL(string:"https://covers.openlibrary.org/b/id/\(book.cover_i).jpg") )
                    }}
                } else {ProgressView()}
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }.onAppear(perform:{
            vm.fetchBooks()
        })
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    BooksView()
        .modelContainer(for: Item.self, inMemory: true)
}
