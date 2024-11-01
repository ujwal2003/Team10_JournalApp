//
//  HeadingToolBarView.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/31/24.
//

import SwiftUI

struct HeadingToolBarView: View {
    var contentTitle: String
    var isEditVisible: Bool
    var isEditing: Bool
    
    var onEditClick: () -> Void
    var onAddIconClick: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(contentTitle)
                .font(.system(size: 24))
                .fontWeight(.semibold)
            
            Spacer()
            
            if isEditVisible {
                Button(action: { onEditClick() }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.system(size: 20))
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                }
            }
            
            Button(action: { onAddIconClick() }) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
        }
        .padding()
        .padding(.horizontal)
    }
}
