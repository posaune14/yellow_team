//
//  VolunteerViewModel.swift
//  PantryLink
//
//  Created by Michael Youtz on 8/5/25.
//

import Foundation

class VolunteerViewModel: ObservableObject {
    
    func register_volunteer(volunteer: Volunteer){
        guard let url = URL(string: "http://127.0.0.1:5000") else {
            return
        }
        
        //request: takes inputed data, changes it to json, and sends it to the database
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            //let jsonData = try JSONEncoder().encode(volunteer)
            print(volunteer.first_name)
        }
        
        catch{
            print("error uploading volunteer data")
        }
        
    }
}
