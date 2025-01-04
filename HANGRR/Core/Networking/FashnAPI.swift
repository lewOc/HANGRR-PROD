import Foundation
import UIKit

// MARK: - Models
struct TryOnRequest: Codable {
    let model_image: String  // base64 with prefix
    let garment_image: String  // base64 with prefix
    let category: String  // "tops", "bottoms", or "one-pieces"
    let nsfw_filter: Bool = true
}

struct TryOnResponse: Codable {
    let id: String
    let error: String?
}

struct TryOnStatusResponse: Codable {
    let id: String
    let status: TryOnStatus
    let output: [String]?
    let error: String?
}

enum TryOnStatus: String, Codable {
    case starting
    case in_queue
    case processing
    case completed
    case failed
}

enum FashnAPIError: LocalizedError {
    case invalidImage
    case invalidResponse
    case requestFailed(String)
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Failed to process image data"
        case .invalidResponse:
            return "Invalid response from server"
        case .requestFailed(let message):
            return "Request failed: \(message)"
        case .apiError(let message):
            return "API error: \(message)"
        }
    }
}

// MARK: - API Client
actor FashnAPIClient {
    private let baseURL = "https://api.fashn.ai/v1"
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func headers() -> [String: String] {
        ["Authorization": "Bearer \(apiKey)",
         "Content-Type": "application/json"]
    }
    
    func submitTryOn(modelImage: UIImage, garmentImage: UIImage, category: String) async throws -> String {
        guard let modelBase64 = modelImage.jpegData(compressionQuality: 0.8)?.base64EncodedString(),
              let garmentBase64 = garmentImage.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            throw FashnAPIError.invalidImage
        }
        
        let request = TryOnRequest(
            model_image: "data:image/jpeg;base64,\(modelBase64)",
            garment_image: "data:image/jpeg;base64,\(garmentBase64)",
            category: category
        )
        
        let url = URL(string: "\(baseURL)/run")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.allHTTPHeaderFields = headers()
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FashnAPIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw FashnAPIError.requestFailed("Status code: \(httpResponse.statusCode)")
        }
        
        let tryOnResponse = try JSONDecoder().decode(TryOnResponse.self, from: data)
        if let error = tryOnResponse.error {
            throw FashnAPIError.apiError(error)
        }
        
        return tryOnResponse.id
    }
    
    func checkStatus(id: String) async throws -> TryOnStatusResponse {
        let url = URL(string: "\(baseURL)/status/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers()
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FashnAPIError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw FashnAPIError.requestFailed("Status code: \(httpResponse.statusCode)")
        }
        
        return try JSONDecoder().decode(TryOnStatusResponse.self, from: data)
    }
} 