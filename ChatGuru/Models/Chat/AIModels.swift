//
//  AIModels.swift
//  ChatGuru
//
//  Created by Gurvineet Dhillon on 3/19/23.
//

import Foundation
struct AIRequest: Encodable {
    let prompt: String
    let temperature: Double
    let maxTokens: Int
    let apiKey: String
    let promptPrefix: String
    
    enum CodingKeys: String, CodingKey {
        case prompt
        case temperature
        case maxTokens = "max_tokens"
        case apiKey = "api_key"
        case promptPrefix = "prompt_prefix"
    }
}

struct AIResponse: Decodable {
    let choices: [AIChoice]
}

struct AIChoice: Decodable {
    let text: String
}
