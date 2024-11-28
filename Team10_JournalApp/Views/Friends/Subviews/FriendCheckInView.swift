//
//  FriendCheckInView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/23/24.
//

import SwiftUI

struct FriendCheckInView: View {
    @State var friendDBInfo: DBUserInfo
    
    var body: some View {
        VStack {
            VStack(spacing: 15.0) {
                Text("\(friendDBInfo.displayName)'s City")
                    .font(.system(size: 30))
                    .fontWeight(.heavy)
                    .foregroundStyle(.black)
                
                Text("City Block: Loading...")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
            }
            .padding()
            
            UserJournalCityBlockView(
                map: .LoadingMap,
                buildings: []
            )
            
            VStack {
                Text("\(friendDBInfo.displayName)’s City weather is: ")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                
                let friendWeather = JournalWeather.Cloudy.weatherStatusStyle
                
                HStack {
                    Text(friendWeather.name)
                        .font(.system(size: 18))
                        .fontWeight(.heavy)
                    
                    Image(systemName: friendWeather.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: friendWeather.iconWidth)
                        .foregroundStyle(friendWeather.iconColor)
                }
            }
            .padding()
            
            Spacer()
            
        }
    }
}

#Preview {
    FriendCheckInView(friendDBInfo: .init(userID: "iuyeiqwyiq8276388", email: "test", displayName: "Friend1"))
}
