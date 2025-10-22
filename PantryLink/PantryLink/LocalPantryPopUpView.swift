//
//  LocalPantryPopUpView.swift
//  PantryLink
//
//  Created by Michael Youtz on 10/21/25.
//

import SwiftUI
import MapKit

struct LocalPantryPopUpView: View{
    var pantryAddress: String = "None"
    var pantryNumber: String = "none"
    var pantryURL: URL?
    
    var body: some View{
        VStack{
            Text(pantryAddress)
            Text(pantryNumber)
            if let pantryURL{
                Link("Website Link", destination: pantryURL)
            } else {
                Text("No link available")
            }
        }
    }
}
