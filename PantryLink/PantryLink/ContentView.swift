//
//  ContentView.swift
//  PantryLink
//
//  Created by Joshua Sambol on 5/27/25.
//

import SwiftUI

//create colors
struct Colors {
    static let customBrown: Color = Color("customBrown")
    static let customGreen: Color = Color("customGreen")
    static let customLightGray: Color = Color("customLightGray")
    static let customDarkGray: Color = Color("customDarkGray")
    
}

struct ContentView: View {
    //form 1 data fields
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""
    
    //form 2 data fields
    @State var role: String = ""
    @State var availability: String = ""
    @State var contact_name: String = ""
    @State var contact_number: String = ""
    
    //pop up variable
    @State var isClicked = false
    
    var body: some View {
        ScrollView {
            
            //title
            VStack{
                Text("Start Volunteering").font(.system(size: 48, weight: .black, design: .serif)).foregroundStyle(.white).multilineTextAlignment(.center)
                Text("Today").font(.system(size: 48, weight: .light, design: .rounded)).foregroundStyle(.customGreen)
            }.padding(20)
            
            //paragraph
            VStack{
                Text("Earn community service hours, respect, and a good feeling").font(.system(size: 28, weight: .bold, design: .serif)).foregroundStyle(.white).frame(maxWidth: 300)
            }
            
            //volunteer oppertunities
            VStack(spacing: 0){
                ZStack(){
                    Rectangle().frame(width: 300, height: 125).foregroundStyle(.customLightGray)
                    Text("Volunteer Opportunities").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.customGreen).multilineTextAlignment(.leading).frame(width: 300)
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customDarkGray)
                    Text("Food Distribution").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customLightGray)
                    Text("Sorting/Packing").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customDarkGray)
                    Text("Delivery").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customLightGray)
                    Text("Admin Support").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customDarkGray)
                    Text("Fundraising Support").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.customLightGray)
                    Text("Cleaning/Sanitation").font(.system(size: 30, weight: .light))
                }
            }.padding(20).frame(width: 400, height: 675)
            
            //register form
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)).foregroundStyle(.customLightGray).frame(width: 300, height: isClicked ? 775:875)
                
                if !isClicked{
                    Form{
                        Section(header: Text("Register as a Volunteer").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.customGreen).multilineTextAlignment(.leading)){}
                        
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
                            isClicked = true
                            print("Register")
                        })  {
                            Text("Register").font(.system(size: 20, weight: .bold, design: .rounded)).frame(height: 40)
                        }.frame(maxWidth: .infinity, alignment: .center).background(Color.customGreen).foregroundStyle(.white)){}
                        
                    }.frame(width: 300, height: 850)
                        .padding(40).scrollContentBackground(.hidden)
                    
                } else {
                    
                    Form{
                        //Text
                        Section(header: Text("We're Glad You Are Interested").font(.system(size: 32, weight: .light, design: .rounded)).foregroundStyle(.black).multilineTextAlignment(.leading)){}
                        Section(header: Text("Before you continue, we need more information").font(.system(size: 28, weight: .regular, design: .serif)).foregroundStyle(.customGreen).multilineTextAlignment(.leading)){}
                        
                        //preferred roles
                        Section(header: Text("Preferred Roles").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                            VStack{
                                TextField(
                                    "", text: $role
                                )
                            }
                        }
                        
                        //availability
                        Section(header: Text("Availability").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                            VStack{
                                TextField(
                                    "", text: $availability
                                )
                            }
                        }
                        
                        //Emergency Contact
                        Section(header: Text("Emergency Contact").font(.system(size: 16, weight: .bold)).foregroundStyle(.black)){
                            VStack{
                                TextField(
                                    "Name", text: $contact_name
                                )
                                TextField(
                                    "Phone Number", text: $contact_number
                                )
                            }
                        }
                        
                        Section(header: Button(action: {
                            print("continue")
                        })  {
                            Text("Continue").font(.system(size: 20, weight: .bold, design: .rounded)).frame(height: 40)
                        }.frame(maxWidth: .infinity, alignment: .center).background(.customGreen).foregroundStyle(.white)){}
                        
                    }.frame(width: 300, height: 750).padding(40).scrollContentBackground(.hidden)
                }
                
            }.animation(.easeIn(duration: 1.5), value: isClicked)
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBrown)
        
    }
}

#Preview {
    ContentView()
}
