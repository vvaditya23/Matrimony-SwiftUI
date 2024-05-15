//
//  FilterView.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 13/05/24.
//

import SwiftUI

struct FilterView: View {
    @Binding var showFilterView: Bool
    @State var genderSelection: String = ""
    
    let genders = ["Any", "Male", "Female"]
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Select gender")
                    Spacer()
                }
                HStack {
                    Picker("Select gender", selection: $genderSelection) {
                        ForEach(genders, id: \.self) { element in
                            Text(element)
                        }
                    }
                    .pickerStyle(.menu)
                    .foregroundColor(.black)
                    
                    Spacer()
                }
                Text("")
                    .frame(width: UIScreen.main.bounds.width - 20, height: 1)
                    .background(.gray)
                Spacer()
                Button(action: {
                    var genderSelectionString = ""
                    if genderSelection == "Male" {
                        genderSelectionString = "male"
                    } else if genderSelection == "Female" {
                        genderSelectionString = "female"
                    }
                    NotificationCenter.default.post(name: .GenderSelectionRefresh, object: nil, userInfo: ["gender": genderSelectionString])
                    showFilterView.toggle()
                }, label: {
                    Text("Apply filter")
                })
                .padding()
                .frame(width: UIScreen.main.bounds.width - 20)
                .border(.black, width: 1)
            }
            .padding()
            .navigationTitle("Let's find the one for you...")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilterView.toggle()
                    } label: {
                        Text("Close")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

extension Notification.Name {
    static let GenderSelectionRefresh = Notification.Name("GenderSelectionRefresh")
}
