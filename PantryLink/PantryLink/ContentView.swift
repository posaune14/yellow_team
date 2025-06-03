//
//  ContentView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//

import SwiftUI
//add colors here

struct ContentView: View {
    var body: some View {
        ScrollView {
            
            //title
            VStack{
                Text("Start Volunteering").font(.system(size: 48, weight: .black, design: .serif)).foregroundStyle(.white).multilineTextAlignment(.center)
                Text("Today").font(.system(size: 48, weight: .light, design: .rounded)).foregroundStyle(.green)
            }.padding(20)
            
            //paragraph
            VStack{
                Text("Earn community service hours, respect, and a good feeling").font(.system(size: 40, weight: .bold, design: .serif)).foregroundStyle(.white)
            }
            
            //register form
            Form{
                Section(header: Text("Register as a Volunteer").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.green).multilineTextAlignment(.center)){
                    //textfield
                }
            }
            .frame(width: 300, height: 1000)
            .padding(20)
          
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)

    }
}

#Preview {
    ContentView()
}
