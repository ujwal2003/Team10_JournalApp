//
//  BottomNavigationView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/20/24.
//

import SwiftUI

struct BottomNavigationView: View {
    var isDisabled: Bool
    var onLeftArrowClick: () -> Void
    var onRightArrowClick: () -> Void
    var currWeek: String
    var numFriends: Int
    
    var body: some View {
        HStack {
            Button(action: { onLeftArrowClick() }, label: {
                Image(systemName: "arrow.left.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                    .opacity(isDisabled ? 0.4 : 1)
            })
            .disabled(isDisabled)
            .padding()
            
            Spacer()
            
            VStack(spacing: 4.0) {
                Text("City Block:")
                    .font(.system(size: 16))
                
                Text(currWeek)
                    .font(.system(size: 15.35))
                    .foregroundStyle(Color(red: 66/255,
                                           green: 100/255,
                                          blue: 125/255))
               
                HStack(spacing: 4.0) {
                    Text("Connected to")
                        .font(.system(size: 16))
                    
                    Text("\(numFriends)")
                        .font(.system(size: 16))
                        .foregroundStyle(Color(red: 66/255,
                                               green: 100/255,
                                               blue: 125/255))
                    
                    Text("cities")
                        .font(.system(size: 16))
                }
            }
            
            Spacer()
            
            Button(action: { onRightArrowClick() }, label: {
                Image(systemName: "arrow.right.square")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .foregroundStyle(Color(red: 0.09, green: 0.28, blue: 0.39))
                    .opacity(isDisabled ? 0.4 : 1)
            })
            .disabled(isDisabled)
            .padding()
            
        }.padding([.leading, .bottom, .trailing])
    }
}
