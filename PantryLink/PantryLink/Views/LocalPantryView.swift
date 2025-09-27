//
//  LocalPantryView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 8/6/25.
//

import SwiftUI

struct LocalPantryView: View {
    let slides: [Color] = [.red, .green, .blue, .orange, .purple]
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.stockLightTan)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 25)
                .fill(.stockDarkTan)
                .frame(width:350, height:350)
                .shadow(radius: 10)
            VStack{
                Text("Local Pantries")
                    .bold()
                    .foregroundColor(.white)
                    .font(.title)
                TabView{
                    Image("H_FoodBank").resizable().scaledToFit()
                    ForEach(1..<slides.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(slides[index])
                            .frame(height:200)
                            .padding(40)
                            
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 285)
            }
        }
    }
}

#Preview {
    LocalPantryView()
}
