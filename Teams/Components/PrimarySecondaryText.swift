//
//  PrimarySecondaryText.swift
//  Teams
//
//  Created by Shyam Kumar on 12/31/22.
//

import SwiftUI

struct PrimarySecondaryText: View {
    
    enum TextOrdering {
        case primaryFirst
        case secondaryFirst
    }
    
    var primary: String
    var secondary: String
    var font: Font? = nil
    var textAlignment: TextAlignment = .center
    var lineSpacing: CGFloat = 10
    var primaryColor: Color = .secondaryTextOnWhite
    var secondaryColor: Color = .black
    var textOrdering: TextOrdering = .primaryFirst
    
    var body: some View {
        switch textOrdering {
        case .primaryFirst:
            (Text("\(primary) ")
                .foregroundColor(primaryColor)
                .font(font ?? .mediumSubtitle) +
            
            Text(secondary)
                .foregroundColor(secondaryColor)
                .font(font ?? .mediumSubtitle))
            .multilineTextAlignment(textAlignment)
            .lineSpacing(lineSpacing)
        case .secondaryFirst:
            (Text(secondary)
                .foregroundColor(secondaryColor)
                .font(font ?? .mediumSubtitle) +
            
             Text("\(primary) ")
                 .foregroundColor(primaryColor)
                 .font(font ?? .mediumSubtitle))
            .multilineTextAlignment(textAlignment)
            .lineSpacing(lineSpacing)
        }
    }
}

struct PrimarySecondaryText_Previews: PreviewProvider {
    static var previews: some View {
        PrimarySecondaryText(primary: "GOLDEN STATE\n", secondary: "WARRIORS")
    }
}
