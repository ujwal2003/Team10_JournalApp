//
//  DefaultRectContainer.swift
//  Team10_JournalApp
//
//  Created by ujwal joshi on 10/9/24.
//

import SwiftUI

struct FrameRectHeadText {
    var text: String
    var fontSize: CGFloat
}

enum HeadTextLocation {
    case leftAlign
    case leftCentralAlign
    case topAlign
    case topCentralAlign
}

struct DefaultRectContainer<Content: View>: View {
    var title: FrameRectHeadText
    var subtitle: FrameRectHeadText
    
    var minifiedFrame: Bool
    var headLeftAlign: HeadTextLocation
    var headTopAlign: HeadTextLocation
    let content: Content
    
    init(title: FrameRectHeadText,
         subtitle: FrameRectHeadText,
         minifiedFrame: Bool = false,
         headLeftAlign: HeadTextLocation = .leftAlign,
         headTopAlign: HeadTextLocation = .topAlign,
         @ViewBuilder content: () -> Content) {
        
        self.title = title
        self.subtitle = subtitle
        
        self.minifiedFrame = minifiedFrame
        self.headLeftAlign = headLeftAlign
        self.headTopAlign = headTopAlign
        
        self.content = content()
    }
    
    var body: some View {
        Color(.backgroundBlue).ignoresSafeArea()
            .overlay {
                VStack {
                    
                    VStack {
                        Text(title.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: title.fontSize).weight(.heavy))
                            .padding(.horizontal)
                        
                        Text(subtitle.text)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: subtitle.fontSize).weight(.medium))
                            .padding(.horizontal)
                    }
                    .padding()
                    .padding(.top, headTopAlign == .topCentralAlign ? 40.0 : 0.0)
                    .padding(headLeftAlign == .leftCentralAlign ? 20 : 0.0)
                    
                    Spacer()
                        .frame(height: minifiedFrame ? 10.0 : 0.0)
                    
                    ZStack {
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .background(Color.white)
                            .frame(maxHeight: .infinity)
                            .clipShape(RoundedCorner(radius: 25.0,
                                                     corners: [.topLeft, .topRight]))
                            .ignoresSafeArea()
                        
                        VStack {
                            content
                        }
                    }
                    
                }
            }
    }
}

#Preview {
    DefaultRectContainer(title: .init(text: "Title", fontSize: 40.0),
                         subtitle: .init(text: "Insert subtitle here", fontSize: 20.0)) {
        Text("hi")
            .foregroundStyle(Color.black)
            .font(.largeTitle)
        
    }
}
