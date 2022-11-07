//
//  CocktailAPIController.swift
//  findMeADrink
//
//  Created by Matthew Rawlings on 11/1/22.
//

import Foundation

class CocktailAPIController {
    
    static let baseURL = URL(string: "https://the-cocktail-db.p.rapidapi.com")
    
    static let listComponent = "list.php"
    static let filterComponent = "filter.php"
    static let lookupComponent = "lookup.php"
    
    static let ingredientKey = "i"
    static let categoryKey = "c"
    static let idKey = "i"
    
    static func fetchCategories(completion: @escaping (Result<[String],NetworkError>) -> Void) {
        guard let finalURL = URL(string: "https://the-cocktail-db.p.rapidapi.com/list.php?c=list") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: finalURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {
                completion(.failure(.badData))
                return
            }

            do {
                let topLevelObject = try JSONDecoder().decode(Categories.self, from: data)
                let drinks = topLevelObject.drinks
                var drinkCategories: [String] = []
                drinkCategories.append(contentsOf: drinks.map { ($0.category) })
                return completion(.success(drinkCategories))
            } catch {
                print("\(error)\n===========================================")
                print("\(error.localizedDescription)\n===========================================")
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //https://the-cocktail-db.p.rapidapi.com/filter.php?c={{CATEGORY}}
    static func filterBy(category: String, completion: @escaping (Result<[FilteredCategories.Drink], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let filterURL = baseURL.appendingPathComponent(filterComponent)
        
        var components = URLComponents(url: filterURL, resolvingAgainstBaseURL: true)
        let categoryQuery = URLQueryItem(name: categoryKey, value: category)
        
        components?.queryItems = [categoryQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        var request = URLRequest(url: finalURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data else { return completion(.failure(.badData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(FilteredCategories.self, from: data)
                let drinks = topLevelObject.drinks
                return completion(.success(drinks))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //https://the-cocktail-db.p.rapidapi.com/lookup.php?i={{drinkID}}
    static func fetchDetailsBy(id: String, completion: @escaping (Result<[DrinkDetails.Drink], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let lookupComponent = baseURL.appendingPathComponent(lookupComponent)
        
        var components = URLComponents(url: lookupComponent, resolvingAgainstBaseURL: true)
        let idQuery = URLQueryItem(name: idKey, value: id)
        components?.queryItems = [idQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }

        var request = URLRequest(url: finalURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data else { return completion(.failure(.badData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(DrinkDetails.self, from: data)
                let drinkDetails = topLevelObject.drinks
                return completion(.success(drinkDetails))
            } catch {
                print("\(error)\n===========================================")
                print("\(error.localizedDescription)\n===========================================")
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    //https://the-cocktail-db.p.rapidapi.com/filter.php?i={{INGREDIENT}}
    static func searchBy(ingredient: String, completion: @escaping (Result<[FilteredCategories.Drink], NetworkError>) -> Void) {
        guard let baseURL else { return completion(.failure(.invalidURL)) }
        let filterURL = baseURL.appendingPathComponent(filterComponent)
        
        var components = URLComponents(url: filterURL, resolvingAgainstBaseURL: true)
        let ingredientQuery = URLQueryItem(name: ingredientKey, value: ingredient)
        components?.queryItems = [ingredientQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        var request = URLRequest(url: finalURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data else { return completion(.failure(.badData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(FilteredCategories.self, from: data)
                let results = topLevelObject.drinks
                return completion(.success(results))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
} //end of controller
