//
//  ContentView.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/4/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = HomeViewModel()
    @State var addingNewGrocery = false
    @State var isAddingMultiple = false
    @State var settings = false
    @Binding var changeView: AppType
    
    
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    @State var sharingCode = false
    @State var familyCode = FirebaseExtension().loadFamilyCode()
    @State var familyName = FirebaseExtension().loadFamilyName()
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.itemReturnables) { store in
                        if store.items.count > 0 {
                            Section(store.storeName) {
                                ForEach(store.items, id: \.self) { grocery in
                                    HStack {
                                        HStack {
                                            CheckmarkButton(id: "\(grocery.id)", size: 14) { _, _ in
                                                viewModel.remove(this: grocery, at: store)
                                            }.foregroundColor(Color.black)
                                            Text(grocery.name.capitalized)
                                        }
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Text("\(grocery.amount)").bold()
                                            Text(grocery.container)
                                        }.padding(.trailing, 5)
                                    }.swipeActions(edge: .trailing) {
                                        Button {
                                            viewModel.remove(this: grocery, at: store)
                                        } label: {
                                            Label("", systemImage: "delete.forward")
                                        }
                                        .tint(.red)
                                    }.animation(Animation.easeInOut(duration: 0.5), value: 1)
                                }
                            }
                        }
                    }
                }
                
            }
            .sheet(isPresented: $addingNewGrocery, content: {
                AddGroceryView(callback: { name, amount, container, store, id in
                    for (d, r) in viewModel.itemReturnables.enumerated() {
                        if r.storeName == store {
                            viewModel.itemReturnables[d].items.append(ItemModel.Item(id: id, name: name, amount: amount, container: container, store: store))
                        }
                    }
                    isAddingMultiple = false
                    viewModel.sort()
                }, isAddingMultiple: isAddingMultiple)
            })
            .sheet(isPresented: $settings, content: {
                NavigationView {
                    List {
                        Button(action: {
                            if let userDefaults = UserDefaults(suiteName: "group.com.shravanprasanth.Groceries") {
                                guard let id = userDefaults.value(forKey: "family_id") as? Int else {
                                    alertTitle = "Error"
                                    alertMessage = "You have not joined a family on the iOS App!"
                                    showAlert.toggle()
                                    return
                                }
                                
                                WatchConnectivityManager.shared.send(id)
                                
                                alertTitle = "Refresh"
                                alertMessage = "Tap the Refresh Button on the Apple Watch App"
                                showAlert.toggle()
                            }
                            else {
                                alertTitle = "Error"
                                alertMessage = "You have not joined a family on the iOS App!"
                                showAlert.toggle()
                            }
                        }) {
                            Label {
                                Text("Connect Watch")
                            } icon:  {
                                Image(systemName: "applewatch")
                            }
                        }.alert(isPresented: $showAlert) {
                            Alert(title: Text(alertTitle), message: Text(alertMessage))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("App icons created by Freepik - Flaticon")
                            Link(destination: URL(string: "https://www.flaticon.com/free-icons/harvest")!) {
                                Text("https://www.flaticon.com/free-icons/harvest")
                            }
                        }
                        
                        Button(action: {
                            sharingCode.toggle()
                        }) {
                            Label {
                                Text("Share Family Code")
                            } icon: {
                                Image(systemName: "square.and.arrow.up")
                            }
                        }.sheet(isPresented: $sharingCode) {
                            ShareSheet(activityItems: ["Join '\(familyName)'! \nFamily Code: \(familyCode) \n\nhttps://google.com"])
                        }

                        Button(action: {
                            settings = false
                            changeView = .NO_ID
                            UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(nil, forKey: "family_id")
                            UserDefaults(suiteName: "group.com.shravanprasanth.Groceries")?.setValue(nil, forKey: "family_name")

                        }) {
                            Label {
                                Text("Leave Family")
                            } icon: {
                                Image(systemName: "person.badge.minus")
                            }
                        }

                        Text("Copyright © 2022 - Shravan Prasanth (Balan)")
                    }.navigationBarTitle("Settings")
                }
            })
            .navigationBarTitle("\(viewModel.itemCount) Items")
            .navigationBarItems(trailing: Menu("+") {
                Button(action: {
                    isAddingMultiple = false
                    addingNewGrocery.toggle()
                }) {
                    Label {
                        Text("Single Groceries")
                    } icon: {
                        Image(systemName: "1.circle")
                    }
                }
                Button(action: {
                    isAddingMultiple = true
                    addingNewGrocery.toggle()
                }) {
                    Label {
                        Text("Multiple Groceries")
                    } icon: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                Button(action: {
                    settings.toggle()
                }) {
                    Label {
                        Text("Settings")
                    } icon: {
                        Image(systemName: "gear")
                    }

                }
            }.scaleEffect(1.8))
        }
        .onAppear {
            viewModel.loadGroceries()
            DispatchQueue.global().async {
                FirebaseExtension().listenForUpdates { bool in
                    if bool {
                        viewModel.loadGroceries()
                    }
                }
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
