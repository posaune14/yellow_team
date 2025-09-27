//
//  PantryViewModel.swift
//  PantryLink
//
//  Created by Joshua Sambol on 9/27/25.
//

import Foundation
import SwiftUI

@MainActor
class PantryViewModel: ObservableObject {
    @Published var pantrys: [PantryModel] = []
    @Published var selectedPantry: PantryModel?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Replace with your Python server URL
    private let baseURL = "http://localhost:5000/api"  // or your production URL
    
    // MARK: - API Methods
    func fetchAllPantrys() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pantrys = try await performGetRequest(endpoint: "/pantrys", responseType: PantryResponse.self)
            self.pantrys = pantrys.pantrys
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPantryById(_ id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await performGetRequest(endpoint: "/pantrys/\(id)", responseType: SinglePantryResponse.self)
            self.selectedPantry = response.pantry
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPantrysByLocation(_ location: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pantrys = try await performGetRequest(endpoint: "/pantrys?location=\(location)", responseType: PantryResponse.self)
            self.pantrys = pantrys.pantrys
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPantrysByUsername(_ username: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pantrys = try await performGetRequest(endpoint: "/pantrys?username=\(username)", responseType: PantryResponse.self)
            self.pantrys = pantrys.pantrys
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPantryStock(_ pantryId: String) async -> [StockItem] {
        do {
            let response = try await performGetRequest(endpoint: "/pantrys/\(pantryId)/stock", responseType: SinglePantryResponse.self)
            return response.pantry.stock
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
    
    func searchPantrysWithStock(minStockLevel: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pantrys = try await performGetRequest(endpoint: "/pantrys?min_stock=\(minStockLevel)", responseType: PantryResponse.self)
            // Filter pantrys that have items with current stock above threshold
            self.pantrys = pantrys.pantrys.filter { pantry in
                pantry.stock.contains { stock in
                    stock.current >= minStockLevel
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func searchPantrysWithLowStock() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let pantrys = try await performGetRequest(endpoint: "/pantrys", responseType: PantryResponse.self)
            // Filter pantrys that have items running low (current < 50% of full)
            self.pantrys = pantrys.pantrys.filter { pantry in
                pantry.stock.contains { stock in
                    stock.full > 0 && (Double(stock.current) / Double(stock.full)) < 0.5
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchPantryStream(_ pantryId: String) async -> [StreamEntry] {
        do {
            let response = try await performGetRequest(endpoint: "/pantrys/\(pantryId)/stream", responseType: SinglePantryResponse.self)
            return response.pantry.stream
        } catch {
            self.errorMessage = error.localizedDescription
            return []
        }
    }
    
    // MARK: - Private Network Layer
    private func performGetRequest<T: Codable>(endpoint: String, responseType: T.Type) async throws -> T {
        guard let encodedEndpoint = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: baseURL + encodedEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedResponse = try decoder.decode(responseType, from: data)
            return decodedResponse
        } catch {
            print("Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON: \(jsonString)")
            }
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Helper Methods
    func clearError() {
        errorMessage = nil
    }
    
    func refreshData() async {
        await fetchAllPantrys()
    }
    
    // Get total stock count for a pantry
    func getTotalStockCount(for pantry: PantryModel) -> Int {
        return pantry.stock.reduce(0) { total, item in
            total + item.current
        }
    }
    
    // Get stock capacity percentage for a pantry
    func getStockCapacityPercentage(for pantry: PantryModel) -> Double {
        let totalCurrent = pantry.stock.reduce(0) { $0 + $1.current }
        let totalFull = pantry.stock.reduce(0) { $0 + $1.full }
        
        guard totalFull > 0 else { return 0.0 }
        return (Double(totalCurrent) / Double(totalFull)) * 100
    }
    
    // Get low stock items for a pantry
    func getLowStockItems(for pantry: PantryModel, threshold: Double = 0.3) -> [StockItem] {
        return pantry.stock.filter { item in
            guard item.full > 0 else { return false }
            let percentage = Double(item.current) / Double(item.full)
            return percentage <= threshold
        }
    }
    
    // Get stock items by type
    func getStockItemsByType(for pantry: PantryModel, type: String) -> [StockItem] {
        return pantry.stock.filter { item in
            item.type.lowercased() == type.lowercased()
        }
    }
}

// MARK: - Error Handling
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error with status code: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
