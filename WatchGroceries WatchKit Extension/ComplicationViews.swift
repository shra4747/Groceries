//
//  ComplicationViews.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import SwiftUI
import ClockKit

struct ComplicationViewCircular: View {

    @State var itemCount: Int
    
    var body: some View {
        ZStack {
            ProgressView(value: 1.0, total: 1.0) {
                HStack(spacing: 0) {
                    Text("\(itemCount)")
                    Image(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")
                        .scaleEffect(0.9)
                }
            }.progressViewStyle(CircularProgressViewStyle(tint: .blue))
        }
    }
}

struct ComplicationViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicRectangularStandardBody(headerImageProvider: nil, headerTextProvider: CLKTextProvider(format: "1 Item"), body1TextProvider: CLKTextProvider(format: " - Walmart\n - ShopRite")).previewContext()
            
            CLKComplicationTemplateModularLargeStandardBody(headerImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: "cart")!), headerTextProvider: CLKTextProvider(format: "1 Items"), body1TextProvider: CLKTextProvider(format: " - Walmart\n - ShopRite")).previewContext()
        }
    }
}
