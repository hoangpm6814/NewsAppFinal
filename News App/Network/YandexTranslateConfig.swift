//
//  YandexTranslateConfig.swift
//  News App
//
//  Created by Hang Thanh on 1/8/20.
//  Copyright © 2020 LVHhcmus. All rights reserved.
//

import Foundation

class YandexTranslate {
    
    // JSON data response struct
    struct queryResponse: Codable {
        let code: Int
        let lang: String
        let text: [String]
    }
    
    // Translate() comes with a completion handler.
    func translate(phrase: String, toLang: String, completion: @escaping ((String) -> Void)) {
        // assembling the URL
        let translateURL = "https://translate.yandex.net/api/v1.5/tr.json/translate"
        
        // Insert your key into the key constant to use
        let key = "trnsl.1.1.20200108T080159Z.2c9cd847c2e81305.cb788c1c71f09006a8bd2a5699b9a9dbb33db944"
        let text = phrase
        let url_formatted_text = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let lang = toLang
        let format = "plain"
        let Url = URL(string: "\(translateURL)" + "?key=\(key)&text=\(url_formatted_text!)&lang=\(lang)&format=\(format)")!
        
        var request = URLRequest(url: Url)
        // Post the assembled URL
        request.httpMethod = "POST"
        
        // start waiting for the JSON response if data was found then decode it
        let task = URLSession.shared.dataTask(with: request) { (data,
            response, error) in
            if error != nil {
                completion("ERROR: Проблема с соединением")
            }
            if let data = data {
                completion(self.decodeJSON(data: data))
            }
        }
        task.resume()
    }
    
    func decodeJSON(data: Data) -> String  {
        do {
            // data we are getting from API response
            let decoder = JSONDecoder()
            let response = try decoder.decode(queryResponse.self, from: data)
            switch(response.code) {
            case 200: return response.text[0]
            case 401: return "ERROR: Invalid API key"
            case 402: return "ERROR: Blocked API key"
            default:
                return "ERROR"
            }
        } catch {print(error)}
        return "ERROR"
    }
}
