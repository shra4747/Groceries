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
            ProgressView(value: Float(itemCount), total: 10.0) {
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
            CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: "cart")!), line2TextProvider: CLKTextProvider(format: "\(1) items")).previewContext()
            
            CLKComplicationTemplateModularLargeStandardBody(headerImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: "cart")!), headerTextProvider: CLKTextProvider(format: "1 Items"), body1TextProvider: CLKTextProvider(format: " - Walmart\n - ShopRite")).previewContext()
        }
    }
}
