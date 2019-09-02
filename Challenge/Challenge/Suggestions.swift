//
//  Suggestion.swift
//  Challenge
//
//  Created by Marcelo Bogdanovicz on 31/08/19.
//  Copyright © 2019 Critical TechWorks. All rights reserved.
//

import Foundation

struct Suggestions: Decodable {
    
    let suggestions: [Suggestion]
}

struct Suggestion: Decodable {

    let label: String
    let language: String
    let countryCode: String
    let locationId: String
    let address: Address
    let distance: Int?
    let matchLevel: String
}

struct Address: Decodable {
    
    let label: String?
    let country: String
    let state: String?
    let county: String?
    let city: String?
    let district: String?
    let street: String?
    let houseNumber: String?
    let unit: String?
    let postalCode: String?
}
