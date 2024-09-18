//
//  BookModel.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 06/09/24.
//

import Foundation
import SwiftData

@Model
class Book: Codable {
    var author_name:[String]
    var title:String
    @Attribute(.unique) var cover_i:Int
    var first_sentence:[String]
    var id_amazon:[String]
    var image:Data?
    
    init(author_name: [String], title: String, cover_i: Int, first_sentence: [String], id_amazon: [String]) {
        self.author_name = author_name
        self.title = title
        self.cover_i = cover_i
        self.first_sentence = first_sentence
        self.id_amazon = id_amazon
    }
    
    // Manual Encoding
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(author_name, forKey: .author_name)
           try container.encode(title, forKey: .title)
           try container.encode(cover_i, forKey: .cover_i)
           try container.encode(first_sentence, forKey: .first_sentence)
           try container.encode(id_amazon, forKey: .id_amazon)
       }
       
       // Manual Decoding
       required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           author_name = try container.decode([String].self, forKey: .author_name)
           title = try container.decode(String.self, forKey: .title)
           cover_i = try container.decode(Int.self, forKey: .cover_i)
           first_sentence = try container.decode([String].self, forKey: .first_sentence)
           id_amazon = try container.decode([String].self, forKey: .id_amazon)
       }
       
       // Define Coding Keys for Codable
       enum CodingKeys: String, CodingKey {
           case author_name
           case title
           case cover_i
           case first_sentence
           case id_amazon
       }
}

struct BookJson:Codable {
    let docs:[Book]
}
