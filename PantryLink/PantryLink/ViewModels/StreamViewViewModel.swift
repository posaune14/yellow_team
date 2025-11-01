//
//  StreamViewViewModel.swift
//  PantryLink
//
//  Created by Jared Sinai Hernandez Adame on 10/13/25.
//

import Foundation


class StreamViewViewModel: ObservableObject{
    // GetResponseData comes from StreamViewViewModel.swift file
    func getStreams() async throws -> GetResponseData {
        guard let url = URL(string: "https://yellow-team.onrender.com/pantry") else{
            fatalError("Invalid URL")
        }
        
        // Create the get request
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Save the data and response in variables using type destructuring
        let (data, response) = try await URLSession.shared.data(for:request)
        
        // Check the httpResponse for success
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
            throw URLError(.badServerResponse)
        }
        
        // Decoded Response will be of type GetResponseData from StreamViewViewModel.swift file
        let decodedResponse = try JSONDecoder().decode(GetResponseData.self, from: data)
        
        return decodedResponse
    }
}
