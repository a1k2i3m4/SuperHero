//
//  Model.swift
//  SuperHero
//
//  Created by Akimbek Orazgaliev on 27.11.2024.
//

struct SuperHero: Codable {
    let id: Int
    let name: String
    let slug: String
    let powerstats: Powerstats
    let appearance: Appearance
    let biography: Biography
    let images: Images
    
    struct Powerstats: Codable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }
    struct Appearance: Codable {
        let gender: String
        let race: String?
        let height: [String]
        let weight: [String]
    }
    
    struct Biography: Codable {
        let fullName: String
        let alterEgos: String
        let alignment: String
    }
        
    struct Images: Codable {
        let xs: String
        let sm: String
        let md: String
        let lg: String
    }

}
