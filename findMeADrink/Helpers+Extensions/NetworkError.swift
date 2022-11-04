//
//  NetworkError.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/1/22.
//

import Foundation

enum NetworkError: LocalizedError {
case invalidURL
case thrownError(Error)
case badData
case unableToDecode
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            print("URL provided was invalid")
        case .thrownError(let error):
            print("Error -- \(error.localizedDescription)")
        case .badData:
            print("Error handling the data")
        case .unableToDecode:
            print("Unable to decode")
        }
        return ""
    }
}
