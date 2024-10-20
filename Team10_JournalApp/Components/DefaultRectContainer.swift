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
    case signInAlign
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
        LinearGradient(gradient: Gradient(stops: [
                    Gradient.Stop(color: Color(red: 0.866, green: 0.949, blue: 0.992), location: 0.0),
                    Gradient.Stop(color: Color(red: 0.843, green: 0.922, blue: 0.965), location: 0.20),
                    Gradient.Stop(color: Color(red: 0.518, green: 0.565, blue: 0.592), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom)
            .ignoresSafeArea()
            .overlay {
                VStack {
                    // MARK: Title and Subtitle alignment logic
                    VStack(spacing: 10.0) {
                        Text(title.text)
                            .font(.system(size: title.fontSize).weight(.heavy))
                            .frame(maxWidth: .infinity, alignment: alignment(for: headLeftAlign))
                            .padding(.horizontal, headLeftAlign == .signInAlign ? 40 : 16)

                        Text(subtitle.text)
                            .font(.system(size: subtitle.fontSize).weight(.medium))
                            .frame(maxWidth: .infinity, alignment: alignment(for: headLeftAlign))
                            .padding(.horizontal, headLeftAlign == .signInAlign ? 40 : 16)
                    }

                    .padding()
                    .padding(.top, headTopAlign == .topCentralAlign ? 50.0 : 0.0) // Adjust vertical alignment

                    Spacer()
                        .frame(height: minifiedFrame ? 60.0 : 0.0)

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
    
    // MARK: Helper method to determine the alignment based on the headLeftAlign parameter
    func alignment(for location: HeadTextLocation) -> Alignment {
        switch location {
        case .leftAlign:
            return .leading
        case .leftCentralAlign:
            return .center
        case .signInAlign:
            return .leading
        default:
            return .leading
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
