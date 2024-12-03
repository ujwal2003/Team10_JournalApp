//
//  FriendsTestView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 11/30/24.
//

import SwiftUI
import FirebaseFirestore

struct FriendsTestView: View {
    @State var loadedUserProfile: UserProfile?
    
    let testFriendID = "M6uqWrzHdsTa9GJ4qeXnx8bcoaX2"
    
    var body: some View {
        VStack {
            Group {
                if let userProfile = loadedUserProfile {
                    Text("User: \(userProfile.displayName)")
                } else {
                    Text("Loading user...")
                }
            }
            
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            try await FriendsManager.shared.addUserNewFriendWithStatus(
                                userId: userProfile.userId,
                                friendId: testFriendID,
                                status: .incomingRequest
                            )
                        }
                    } catch {
                        print("failed to add new friend with request status.")
                    }
                }
            } label: {
                Text("add new friend with request status")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(BubbleButtonStyle(backgroundColor: Color.blue, textColor: Color.white))
            .padding()
            
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            try await FriendsManager.shared.updateUserFriendStatus(
                                userId: userProfile.userId,
                                friendId: testFriendID,
                                status: .friend
                            )
                        }
                    } catch {
                        print("failed to update friend with friend status.")
                    }
                }
            } label: {
                Text("update friend with friend status")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(BubbleButtonStyle(backgroundColor: Color.mint, textColor: Color.white))
            .padding()
            
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            try await FriendsManager.shared.removeUserFriendWithStatus(
                                userId: userProfile.userId,
                                friendId: testFriendID,
                                status: .friend
                            )
                        }
                    } catch {
                        print("failed to remove friend with friend status.")
                    }
                }
            } label: {
                Text("remove friend with friend status")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(BubbleButtonStyle(backgroundColor: Color.red, textColor: Color.white))
            .padding()
            
            Button {
                Task {
                    do {
                        if let userProfile = loadedUserProfile {
                            let num = try await FriendsManager.shared.getNumberOfFriends(userId: userProfile.userId)
                            print("NUMBER OF FRIENDS: \(num)")
                        }
                    } catch {
                        print("failed to fetch number of friends.")
                    }
                }
            } label: {
                Text("get number of friends")
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            .buttonStyle(BubbleButtonStyle(backgroundColor: Color.cyan, textColor: Color.white))
            .padding()

        }
        .onFirstAppear {
            if let userProfile = loadedUserProfile {
                FriendsManager.shared.addListenerForUserFriendsWithStatus(
                    userId: userProfile.userId,
                    status: .friend,
                    triggeredOn: [.added, .modified, .removed]) { userFriendStatus in
                        print(userFriendStatus)
                    }
            }
        }
        .onDisappear {
            FriendsManager.shared.removeAllUserFriendsListener()
        }
        
    }
}

#Preview {
    FriendsTestView()
}
