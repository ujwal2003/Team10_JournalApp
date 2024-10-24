//
//  RowViews.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/22/24.
//

import SwiftUI

let FRIENDS_ROW_WIDTH: CGFloat = isIphone16ProMaxPortrait ? 380 : 320

struct FriendCheckInRow: View {
    var friendName: String
    var isCheckInVisible: Bool = true
    
    var body: some View {
        HStack {
            Text(friendName)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .fontWeight(.medium)
            
            Spacer()
            
            if isCheckInVisible {
                Text("Check In \(Image(systemName: "chevron.right"))")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            }
        }
        .frame(width: FRIENDS_ROW_WIDTH, height: 35)
        .padding()
        .background(Color.rgb(221, 237, 240))
        .clipShape(RoundedCorner(radius: 15))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 1)
                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.6), lineWidth: 2)
        )
    }
}

struct FriendRequestRow: View {
    var name: String
    var onAcceptClick: () -> Void
    var onRejectClick: () -> Void
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: { onAcceptClick() }) {
                Image(systemName: "checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.hex("#164863"))
            }
            .padding(.trailing)
            
            Button(action: { onRejectClick() }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.hex("#164863"))
            }
        }
        .frame(width: FRIENDS_ROW_WIDTH, height: 35)
        .padding()
        .background(Color.rgb(221, 237, 240))
        .clipShape(RoundedCorner(radius: 15))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 1)
                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.6), lineWidth: 2)
        )
    }
}

struct FriendInviteRow: View {
    var name: String
    var onDismissClick: () -> Void
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .fontWeight(.medium)
            
            Spacer()
            
            Button(action: { onDismissClick() }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(Color.hex("#164863"))
            }
        }
        .frame(width: FRIENDS_ROW_WIDTH, height: 35)
        .padding()
        .background(Color.rgb(221, 237, 240))
        .clipShape(RoundedCorner(radius: 15))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 1)
                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.6), lineWidth: 2)
        )
    }
}
