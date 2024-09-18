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
    @Published private var error: BookError?
    @Published private(set) var isLoading:Bool?
    @Published var textFieldText:String = ""
    @Published var textIsValid:Bool = false
    
    var cancellables = Set<AnyCancellable>()
    init(){
        textFieldSubscriber()
    }
    func textFieldSubscriber(){
        $textFieldText.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map{ (text) -> Bool in
                if text.count > 3 {
                    self.fetchBooks(text)
                    return true
                }
                return false
            }
            .sink(receiveValue: { [weak self] isValid in
                self?.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    
    
    func fetchBooks(_ string:String) -> () {
        let bookUrlString = "https://openlibrary.org/search.json?q=\(string.replacingOccurrences(of: " ", with: "+"))&sort=currently_reading&limit=4&lang=en"
        
        if let url = URL(string: bookUrlString) {
            self.isLoading = true
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
                        self.isLoading = false
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
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm = BooksViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                TextField("Search...", text: $vm.textFieldText)
                    .padding(.leading)
                    .frame(height: 65)
                    .font(.headline)
                    .background(Color(uiColor: .systemGray5)).clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                if let isLoading = vm.isLoading{
                    if !isLoading{
                        ScrollView{
                            ForEach(vm.books,id: \.id_amazon){ book in
                                NavigationLink{BookDetailedView(book: book)} label: {BookCard(book: book)}
                                
                            }
                        }} else{
                            ProgressView()
                            Spacer()
                        }
                            }
            }.padding()
                .navigationTitle("Search a book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading){
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
        }
    }
}

#Preview {
    BooksView()
}
