//
//  ContentView.swift
//  PantryLink
//
//  Created by Michael Youtz on 5/27/25.
//

import SwiftUI

struct VolunteerView: View {
    //form 1 data fields
    @State var first_name: String = ""
    @State var last_name: String = ""
    @State var date_of_birth: String = ""
    @State var email: String = ""
    @State var phone_number: String = ""
    @State var zipcode: String = ""
    
    //form 2 data fields
    @State var roles: String = ""
    @State var availability: String = ""
    @State var emergency_name: String = ""
    @State var emergency_number: String = ""
    
    //pop up variable
    @State var isClicked = false
    
    //alert
    @State var alert_message = ""
    @State var show_alert = false
    
    //unfinished
    @State var empty_field = false
    
 
    
    var body: some View {
        ScrollView {
            
            //title
            VStack{
                Text("Start Volunteering").font(.system(size: 48, weight: .black, design: .serif)).foregroundStyle(.white).multilineTextAlignment(.center)
                Text("Today").font(.system(size: 48, weight: .light, design: .rounded)).foregroundStyle(.green)
            }.padding(20)
            
            //paragraph
            VStack{
                Text("Earn community service hours, respect, and a good feeling").font(.system(size: 28, weight: .bold, design: .serif)).foregroundStyle(.white).frame(maxWidth: 300)
            }
            
            //volunteer oppertunities
            VStack(spacing: 0){
                ZStack(){
                    Rectangle().frame(width: 300, height: 125).foregroundStyle(.flexibleLightGray)
                    Text("Volunteer Opportunities").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.flexibleGreen).multilineTextAlignment(.leading).frame(width: 300)
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleDarkGray)
                    Text("Food Distribution").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleLightGray)
                    Text("Sorting/Packing").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleDarkGray)
                    Text("Delivery").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleLightGray)
                    Text("Admin Support").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleDarkGray)
                    Text("Fundraising Support").font(.system(size: 30, weight: .light))
                }
                ZStack{
                    Rectangle().frame(width: 300, height: 75).foregroundStyle(.flexibleLightGray)
                    Text("Cleaning/Sanitation").font(.system(size: 30, weight: .light))
                }
            }.padding(20).frame(width: 400, height: 675)
            
            //register form
            ZStack{
                RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)).foregroundStyle(.flexibleLightGray).frame(width: 300, height: isClicked ? 775:875)
                
                if !isClicked{
                    Form{
                        Section(header: Text("Register as a Volunteer").font(.system(size: 36, weight: .thin, design: .rounded)).foregroundStyle(.flexibleGreen).multilineTextAlignment(.leading)){}
                        
                        //first name
                        Section(header: Text("First Name").font(.system(size: 16, weight: .bold)).foregroundStyle(first_name.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $first_name
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //last name
                        Section(header: Text("Last Name").font(.system(size: 16, weight: .bold)).foregroundStyle(last_name.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $last_name
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //date of birth
                        Section(header: Text("Date of Birth").font(.system(size: 16, weight: .bold)).foregroundStyle(date_of_birth.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $date_of_birth)
                            }.autocorrectionDisabled(true)
                        }
                        
                        //email
                        Section(header: Text("Email").font(.system(size: 16, weight: .bold)).foregroundStyle(email.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $email
                                ).autocorrectionDisabled(true).textInputAutocapitalization(.never)
                            }
                        }
                        
                        //phone number
                        Section(header: Text("Phone Number").font(.system(size: 16, weight: .bold)).foregroundStyle(phone_number.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $phone_number
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //zipcode
                        Section(header: Text("Zipcode").font(.system(size: 16, weight: .bold)).foregroundStyle(zipcode.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "", text: $zipcode
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //button
                        Section(header: Button(action: {
                            guard !first_name.isEmpty, !last_name.isEmpty, !date_of_birth.isEmpty, !email.isEmpty, !phone_number.isEmpty, !zipcode.isEmpty else {
                                empty_field = true
                                return
                            }
                            empty_field = false
                            isClicked = true
                        })
                        {
                            Text("Register").font(.system(size: 20, weight: .bold, design: .rounded)).frame(height: 40)
                        }.frame(maxWidth: .infinity, alignment: .center).background(Color.flexibleGreen).foregroundStyle(.flexibleWhite)
                        ){}
                        
                    }.frame(width: 300, height: 850)
                        .padding(40).scrollContentBackground(.hidden)
                    
                } else {
                    //neutralizing this
                    
                    Form{
                        //Text
                        Section(header: Text("We're Glad You Are Interested").font(.system(size: 32, weight: .light, design: .rounded)).foregroundStyle(.flexibleBlack).multilineTextAlignment(.leading)){}
                        Section(header: Text("Before you continue, we need more information").font(.system(size: 28, weight: .regular, design: .serif)).foregroundStyle(.flexibleGreen).multilineTextAlignment(.leading)){}
                        
                        //preferred roles
                        Section(header: Text("Preferred Roles").font(.system(size: 16, weight: .bold)).foregroundStyle(roles.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "Delivery, Admin Support, ect.", text: $roles
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //availability
                        Section(header: Text("Availability").font(.system(size: 16, weight: .bold)).foregroundStyle(availability.isEmpty && empty_field ? .red : .flexibleBlack)){
                            VStack{
                                TextField(
                                    "Ex: M-F 9AM to 5AM", text: $availability
                                ).autocorrectionDisabled(true)
                            }
                        }
                        
                        //Emergency Contact
                        Section(header: Text("Emergency Contact").font(.system(size: 16, weight: .bold)).foregroundStyle(.flexibleBlack)){
                            VStack{
                                TextField(
                                    "Full Name", text: $emergency_name
                                ).autocorrectionDisabled(true)
                                TextField(
                                    "Phone Number", text: $emergency_number
                                ).border(emergency_number.isEmpty && empty_field ? .red : .clear).autocorrectionDisabled(true)
                            }
                        }
                        
                        Section(header: Button(action: {
                            guard !availability.isEmpty, !roles.isEmpty, !emergency_name.isEmpty, !emergency_number.isEmpty else {
                                empty_field = true
                                return
                            }
                            
                            let new_volunteer = Volunteer(first_name: first_name, last_name: last_name, date_of_birth: date_of_birth, email: email, phone_number: phone_number, zipcode: zipcode, roles: roles, availability: availability, emergency_name: emergency_name, emergency_number: emergency_number, alert_message: alert_message, show_alert: show_alert)
                            
                                register_volunteer(volunteer: new_volunteer)
                        })  {
                            Text("Continue").font(.system(size: 20, weight: .bold, design: .rounded)).frame(height: 40)
                        }.frame(maxWidth: .infinity, alignment: .center)
                            .background(.flexibleGreen).foregroundStyle(.flexibleWhite)){}
                        
                    }.frame(width: 300, height: 750).padding(40).scrollContentBackground(.hidden)
                    .alert(isPresented: $show_alert){
                    Alert(title: Text("Error"), message: Text(alert_message))
                    }
                }
                
            }.animation(.easeIn(duration: 1.5), value: isClicked)
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.brownBlack)
        
    }
}

#Preview {
    VolunteerView()
    
}
