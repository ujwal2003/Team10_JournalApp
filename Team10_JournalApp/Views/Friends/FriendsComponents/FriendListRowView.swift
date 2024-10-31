//
//  FriendListRowView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/31/24.
//

import SwiftUI

struct FriendsListAcceptRejectButtonsView: View {
    var buttonType: ButtonType
    var action: () -> Void
    
    @State private var isPressed = false
    
    enum ButtonType {
        case Accept; case Reject
    }
    
    init(buttonType: ButtonType, action: @escaping () -> Void) {
        self.buttonType = buttonType
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: buttonType == .Accept ? "checkmark" : "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(Color.hex("#164863"))
                .opacity(isPressed ? 0.5 : 1.0)
        }
        .buttonStyle(.borderless)
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onChanged { _ in
                isPressed = true
            }
            .onEnded { _ in
                isPressed = false
            }
        )
        
    }
}

enum FriendListRowItemContent {
    case emptyContent
    case checkIn
    case requestButtons(onAccept: () -> Void, onReject: () -> Void)
    case inviteRescindButton(onDecline: () -> Void)
    
    func view() -> AnyView {
        switch self {
            case .emptyContent: return AnyView(EmptyView())
            
            case .checkIn: return AnyView(
                Text("Check In \(Image(systemName: "chevron.right"))")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            )
            
            case .requestButtons(let onAccept, let onReject): return AnyView(
                HStack(spacing: 18.0) {
                    FriendsListAcceptRejectButtonsView(buttonType: .Accept, action: onAccept)
                    FriendsListAcceptRejectButtonsView(buttonType: .Reject, action: onReject)
                }
            )
            
            case .inviteRescindButton(let onDecline): return AnyView(
                FriendsListAcceptRejectButtonsView(buttonType: .Reject, action: onDecline)
            )
        }
    }
}

struct FriendListRowView: View {
    @State var itemName: String
    var itemContent: FriendListRowItemContent
    
    init(itemName: String, itemContent: FriendListRowItemContent = .emptyContent) {
        self.itemName = itemName
        self.itemContent = itemContent
    }
    
    var body: some View {
        HStack {
            Text(itemName)
                .foregroundStyle(Color.black)
                .font(.system(size: 20))
                .fontWeight(.medium)
            
            Spacer()
            
            itemContent.view()
        }
        .frame(height: 35)
        .padding()
        .background(Color.rgb(221, 237, 240))
        .clipShape(RoundedCorner(radius: 15))
        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .inset(by: 1)
                .stroke(Color(red: 0.26, green: 0.49, blue: 0.62).opacity(0.6), lineWidth: 1)
        )
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets())
        .padding([.leading, .bottom, .trailing])
    }
}
