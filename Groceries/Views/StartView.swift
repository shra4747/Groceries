//
//  StartView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/10/22.
//

import SwiftUI
import WatchConnectivity

struct StartView: View {
    
    @Binding var changeView: AppType
    @State var isJoiningFamily = false
    @State var familyCode = ""
    @State var familyName = ""
    @State var isCreatingFamily = false
    var wcSession : WCSession! = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Button(action: {
                    isJoiningFamily.toggle()
                }) {
                    ZStack {
                        LinearGradient(colors: [.red, .orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                            .cornerRadius(20)
                        Text("Join Family")
                            .font(.title).bold().foregroundColor(.white)
                    }.shadow(radius: 10)
                }
                Button(action: {
                    isCreatingFamily.toggle()
                }) {
                    ZStack {
                        LinearGradient(colors: [.purple, .blue, .cyan], startPoint: .topTrailing, endPoint: .bottomLeading)
                            .cornerRadius(20)
                        Text("Create Family")
                            .font(.title).bold().foregroundColor(.white)
                    }.shadow(radius: 10)
                }
            }.navigationTitle("Get Started").padding().padding(.bottom, 250)
                .sheet(isPresented: $isJoiningFamily) {} content: {
                    VStack {
                        Text("Ask your Family Member for the Family Code!")
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.title2)
                        TextField("Family Code", text: $familyCode)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .introspectTextField { textField in
                                textField.becomeFirstResponder()
                            }
                            .padding()
                        Button(action: {
                            if !familyCode.isEmpty {
                                FirebaseExtension().checkFamily(familyID: Int(familyCode) ?? 0) { isFamily in
                                    if isFamily {
                                        UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(Int(familyCode), forKey: "family_id")
                                        changeView = .ID_SAVED
                                    }
                                }
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: 55)
                                    .padding(.horizontal, 60)
                                    .foregroundColor(.blue)
                                Text("Join Family")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            }
                        }
                    }
                }
                .sheet(isPresented: $isCreatingFamily) {} content: {
                    VStack {
                        Text("Create a Family!")
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                            .font(.title2)
                        TextField("Family Name: ", text: $familyName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .introspectTextField { textField in
                                textField.becomeFirstResponder()
                            }
                            .padding()
                        Button(action: {
                            if !familyName.isEmpty {
                                let id = Int.random(in: 100000...999999)
                                FirebaseExtension().addFamily(familyName: familyName, familyID: id)
                                isCreatingFamily.toggle()
                                UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(Int(id), forKey: "family_id")
                                changeView = .ID_SAVED
                            }
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: 55)
                                    .padding(.horizontal, 60)
                                    .foregroundColor(.blue)
                                Text("Create Family")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .bold()
                            }
                        }
                    }
                }
        }
    }
}
