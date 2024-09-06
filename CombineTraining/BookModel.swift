//
//  BookModel.swift
//  CombineTraining
//
//  Created by Vitor Kalil on 06/09/24.
//

import Foundation

struct Book: Codable {
    let author_name:[String]
    let title:String
    let subtitle:String?
    let cover_i:Int
    let id_amazon:[String]
}

struct BookJson:Codable {
    let docs:[Book]
}
