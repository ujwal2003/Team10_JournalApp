//
//  AddFriendView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/23/24.
//

import SwiftUI

struct AddFriendView: View {
    @State var searchUserName: String = ""
    @ObservedObject var friendsViewModel: FriendsViewModel
    
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    private var sendButtonDisabled: Bool {
        searchUserName.isEmpty
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: { dismiss() }) {
                    Text("Cancel")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0, green: 0.48, blue: 1))
                }
            }
            .padding()
            
            Text("Connect friends with their username")
                .font(.system(size: 18))
                .fontWeight(.medium)
                .foregroundColor(.black)
            
            TextField("Username", text: $searchUserName)
                .padding()
                .frame(height: 52)
                .background(Color(red: 0.87, green: 0.95, blue: 0.99).opacity(0.5))
                .clipShape(RoundedCorner(radius: 100))
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.61, green: 0.75, blue: 0.78).opacity(0.4), lineWidth: 1)
                )
                .padding()
                .autocorrectionDisabled()
            
            Button(action: {
                Task {
                    await friendsViewModel.sendCityInvite(username: searchUserName)
                }
                
                if friendsViewModel.cityInviteFailed {
                    showAlert.toggle()
                } else {
                    dismiss()
                }
                
            }) {
                Text("Send Invite")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundStyle(Color.white)
                    .opacity(sendButtonDisabled ? 0.4 : 1)
            }
            .frame(maxWidth: .infinity, maxHeight: 52)
            .background(Color(red: 0.61, green: 0.75, blue: 0.78))
            .clipShape(RoundedCorner(radius: 100))
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .padding(.horizontal)
            .disabled(sendButtonDisabled)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invite Failed"),
                      message: Text("Could not find username \(searchUserName) or there was a connection error"),
                      dismissButton: .default(Text("OK"), action: { friendsViewModel.cityInviteFailed = false }))
            }
            
            Spacer()
        }
    }
}

//#Preview {
//    AddFriendView()
//}
