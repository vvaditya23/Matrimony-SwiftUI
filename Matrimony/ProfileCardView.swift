//
//  ProfileCardView.swift
//  Matrimony
//
//  Created by Aditya Vyavahare on 05/05/24.
//
import SwiftUI

struct ProfileCardView: View {
    let profile: RandomProfile

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: profile.picture.large)) { phase in
                switch phase {
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                case .success(let image):
                    image
                        .resizable()
                default:
                    ProgressView()
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(profile.name.first) \(profile.name.last), \(profile.dob.age)")
                            .font(.title)
                            .foregroundStyle(.white)
                        Text("\(profile.location.city), \(profile.location.country)")
                            .foregroundStyle(.white)
                        Text("\(profile.email) · \(profile.nat)")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}
