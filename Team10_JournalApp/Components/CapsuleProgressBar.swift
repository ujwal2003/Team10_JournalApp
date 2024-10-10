//
//  CapsuleProgressBar.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/10/24.
//

import SwiftUI

struct CapsuleProgressBar: View {
    
    @Binding var percent: CGFloat
    @State var percentFontSize: CGFloat
    @State var height: CGFloat
    @State var borderColor: Color
    @State var borderWidth: CGFloat
    @State var barColor: Color
    @State var backgroundColor: Color
    
    init(percent: Binding<CGFloat>,
         percentFontSize: CGFloat = 16.0,
         height: CGFloat = 35.0,
         borderColor: Color,
         borderWidth: CGFloat = 2.0,
         barColor: Color,
         backgroundColor: Color = Color.black.opacity(0.08)) {
        
        self._percent = percent
        self.percentFontSize = percentFontSize
        self.height = height
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.barColor = barColor
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroundColor)
                    .frame(height: height)
                    .overlay {
                        Capsule().stroke(borderColor, lineWidth: 2)
                    }
                
                Capsule()
                    .fill(barColor)
                    .frame(width: self.calcPercent(availableWidth: geometry.size.width), height: height)
                
                Text("\(self.getDisplayPercentage())%")
                    .font(.system(size: percentFontSize).weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
    }
    
    func calcPercent(availableWidth: CGFloat) -> CGFloat {
        
        return availableWidth * self.percent
    }
    
    func getDisplayPercentage() -> Int {
        return Int((self.percent * 100).rounded(.toNearestOrAwayFromZero))
    }
}

#Preview {
    VStack {
        Spacer()
            .frame(height: 200.0)
        
        CapsuleProgressBar(percent: .constant(0.90),
                           percentFontSize: 18.0,
                           height: 35.0,
                           borderColor: Color.blue,
                           borderWidth: 1.5,
                           barColor: Color.blue.opacity(0.4),
                           backgroundColor: Color.black.opacity(0.12))
        .padding()
        
    }.padding()
}
