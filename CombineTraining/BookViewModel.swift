//
//  BookViewModel.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 20/09/24.
//

import SwiftUI
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
                    self?.fetchImage()
                    
                }.store(in: &cancellables)
        }
        
    }
    func fetchImage() {
        for book in self.books{
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://covers.openlibrary.org/b/id/\(book.cover_i).jpg")!)
                .receive(on:DispatchQueue.main)
                .map(handleResponse)
                .sink {resposta in
                    switch resposta{
                    case .failure(let error):
                        print("Error with Image download")
                        print(error.localizedDescription)
                    default:
                        break
                    }
                } receiveValue: {image in
                    book.image = image?.pngData()
                }.store(in: &cancellables)
        }
    }
    
    func handleResponse(data:Data?, response:URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else{
            return nil}
        return image
    }
    
    enum BookError {
        case custom(error:Error)
        case failedToDecode
    }
}
