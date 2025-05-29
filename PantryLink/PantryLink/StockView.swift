//
//  StockView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/29/25.
//
import SwiftUI

struct StockView: View{
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.brown)
                .frame(width:350, height:650)
            VStack{
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width:325, height:110)
                    .overlay(
                        VStack{
                            Text("Princeton Mobile")
                                .bold()
                                .font(.title2)
                            Text("78%")
                                .foregroundColor(.gray)
                                .font(.caption)
                            HStack{
                                ForEach(1..<4){ i in
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 214/255, green: 214/255, blue: 214/255))
                                        .frame(width: 75, height: 30)
                                        .overlay(
                                            Text("Beans")
                                                .scaledToFit()
                                        )
                                }
                            }
                                
                        }
                    )
                
                }
        }
    }
}


#Preview {
    StockView()
}
