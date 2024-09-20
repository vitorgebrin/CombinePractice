//
//  ContentView.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 06/09/24.
//

import SwiftUI
import SwiftData
import Combine

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
