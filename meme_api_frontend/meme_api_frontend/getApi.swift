//
//  GetApi.swift
//  meme_api_frontend
//
//  Created by caramel on 16/12/2024.
//

import Foundation
import UIKit

class MemeAPI {
    
    static let shared = MemeAPI() // Singleton instance if needed
    
    private init() {} // Prevent external initialization
    
    /// Fetches an image from the API
    /// - Parameter completion: A closure returning a UIImage or an error
    func fetchImageFromAPI(completion: @escaping (Result<UIImage, Error>) -> Void) {
        // URL of your Node.js API
        guard let url = URL(string: "https://api.idontcaramel.dev/process-random") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Start the task
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure response data exists
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Parse JSON response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let base64Image = jsonResponse["base64Image"] as? String {
                    
                    // Decode the Base64 string
                    if let imageData = Data(base64Encoded: base64Image, options: .ignoreUnknownCharacters),
                       let image = UIImage(data: imageData) {
                        completion(.success(image))
                    } else {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
