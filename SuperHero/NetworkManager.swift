//
//  NetworkManager.swift
//  SuperHero
//
//  Created by Akimbek Orazgaliev on 29.11.2024.
//
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://akabab.github.io/superhero-api/api"
    
    private init() {}
    
    func fetchAllHeroes(completion: @escaping (Result<[SuperHero], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/all.json")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let heroes = try JSONDecoder().decode([SuperHero].self, from: data)
                completion(.success(heroes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func downloadImage(from urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No image data received"])))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
