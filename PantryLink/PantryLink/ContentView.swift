//
//  ContentView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//

import SwiftUI
//add colors here

struct ContentView: View {
    //data fields
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""
    
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
                Section(header: Text("Register as a Volunteer").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.green).multilineTextAlignment(.center)){}
                    
                //first name
                Section(header: Text("First Name").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $first_name
                        )
                    }
                }
                    
                //last name
                Section(header: Text("Last Name").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $last_name
                        )
                    }
                }
                
                //date of birth
                Section(header: Text("Date of Birth").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $date_of_birth)
                    }
                }
                
                //email
                Section(header: Text("Email").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $email
                        )
                    }
                }
                
                //phone number
                Section(header: Text("Phone Number").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $phone_number
                        )
                    }
                }
                
                //zipcode
                Section(header: Text("Zipcode").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                    VStack{
                        TextField(
                            "", text: $zipcode
                        )
                    }
                }
                
                //button
                Section(header: Button(action: {
                    //button action
                })  {
                    Text("Register").font(.system(size: 20, weight: .bold, design: .rounded)).frame(height: 40)
                }.frame(maxWidth: .infinity, alignment: .center).background(Color.green).foregroundStyle(.white)){}
                    
            }
            .frame(width: 300, height: 850)
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
