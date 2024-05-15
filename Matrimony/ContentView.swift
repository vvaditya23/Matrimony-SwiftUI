//
//  ContentView.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 05/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var profiles = [RandomProfile]()
    @State private var currentPage = 1
    
    let spaceName = "scroll"
    @State var wholeSize: CGSize = .zero
    @State var scrollViewSize: CGSize = .zero
    @State var showFilterView = false
    
    @State var genderReceived = ""
    
    var body: some View {
        NavigationView {
            ChildSizeReader(size: $wholeSize) {
                ScrollView {
                    ChildSizeReader(size: $scrollViewSize) {
                        VStack(spacing: 10) {
                            ForEach(profiles, id: \.self) { profile in
                                ProfileCardView(profile: profile)
                                    .frame(height: wholeSize.height)
                                    .cornerRadius(20)
                            }
                        }
                        .onAppear {
                            fetchRandomProfiles()
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(
                                    key: ViewOffsetKey.self,
                                    value: -1 * proxy.frame(in: .named(spaceName)).origin.y
                                )
                            }
                        )
                        .onPreferenceChange(
                            ViewOffsetKey.self,
                            perform: { value in
                                print("offset: \(value)")
                                print("height: \(scrollViewSize.height)")
                                
                                if value >= scrollViewSize.height - wholeSize.height {
                                    print("User has reached the bottom of the ScrollView.")
                                    currentPage += 1
                                    if genderReceived == "male" {
                                        NetworkManager.shared.fetchRandomProfiles(page: 1, resultsPerPage: 10, gender: "male") { result in
                                            switch result {
                                            case .success(let fetchedProfiles):
                                                print("Fetched profiles: \(fetchedProfiles)")
                                                self.profiles.append(contentsOf: fetchedProfiles)
                                            case .failure(let error):
                                                print("Error fetching profiles: \(error)")
                                            }
                                        }
                                    } else if genderReceived == "female" {
                                        NetworkManager.shared.fetchRandomProfiles(page: 1, resultsPerPage: 10, gender: "female") { result in
                                            switch result {
                                            case .success(let fetchedProfiles):
                                                print("Fetched profiles: \(fetchedProfiles)")
                                                self.profiles.append(contentsOf: fetchedProfiles)
                                            case .failure(let error):
                                                print("Error fetching profiles: \(error)")
                                            }
                                        }
                                    } else {
                                        fetchRandomProfiles()
                                    }
                                } else {
                                    print("not reached.")
                                }
                            }
                        )
                        .padding()
                    }
                }
                .lineSpacing(0)
                .listRowSpacing(0)
                .coordinateSpace(name: spaceName)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .onReceive(NotificationCenter.default.publisher(for: .GenderSelectionRefresh) , perform: { notification in
                    profiles = []
                    NetworkManager.shared.resetSeed()
                    if let gender = notification.userInfo?["gender"] as? String {
                        genderReceived = gender
                        NetworkManager.shared.fetchRandomProfiles(page: 1, resultsPerPage: 10, gender: gender) { result in
                            switch result {
                            case .success(let fetchedProfiles):
                                print("Fetched profiles: \(fetchedProfiles)")
                                self.profiles.append(contentsOf: fetchedProfiles)
                            case .failure(let error):
                                print("Error fetching profiles: \(error)")
                            }
                        }
                    }
                })
            }
            .onChange(
                of: scrollViewSize,
                perform: { value in
                    print(value)
                }
            )
            .navigationBarTitle("Matches")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilterView.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showFilterView) {
                        FilterView(showFilterView: $showFilterView)
                            .interactiveDismissDisabled(true)
                    }
                    
                }
            }
        }
    }
    
    //API call
    func fetchRandomProfiles() {
        NetworkManager.shared.fetchRandomProfiles(page: currentPage, resultsPerPage: 10, gender: "") { result in
            switch result {
            case .success(let fetchedProfiles):
                print("Fetched profiles: \(fetchedProfiles)")
                self.profiles.append(contentsOf: fetchedProfiles)
            case .failure(let error):
                print("Error fetching profiles: \(error)")
            }
        }
    }
}

struct ChildSizeReader<Content: View>: View {
    @Binding var size: CGSize
    
    let content: () -> Content
    var body: some View {
        ZStack {
            content().background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: SizePreferenceKey.self,
                        value: proxy.size
                    )
                }
            )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    
    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

//#Preview {
//    ContentView()
//}
