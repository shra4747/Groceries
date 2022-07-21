//
//  ComplicationController.swift
//  WatchGroceries WatchKit Extension
//
//  Created by Shravan Prasanth on 7/7/22.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Groceries", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(.now)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        FirebaseExtension().getItemCount { itemCount, itemReturnable  in
            if let template = self.makeTemplate(for: itemCount, itemReturnable: itemReturnable, complication: complication) {
                let entry = CLKComplicationTimelineEntry(date: .now, complicationTemplate: template)
                handler(entry)
            }
            else {
                handler(nil)
            }
        }
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        if let template = self.makeTemplate(for: 2, itemReturnable: ItemModel.ItemReturnable(id: UUID(), storeName: "Grocery Store", items: [ItemModel.Item(id: "", name: "Bananas", amount: 1, container: "", store: ""), ItemModel.Item(id: "", name: "Apples", amount: 1, container: "", store: "")]), complication: complication) {
            handler(template)
        }
        else {
            handler(nil)
        }
    }
}

extension ComplicationController {
    func makeTemplate(for itemCount: Int, itemReturnable: ItemModel.ItemReturnable, complication: CLKComplication) -> CLKComplicationTemplate? {
        switch complication.family {
        case .graphicCircular:
            return CLKComplicationTemplateGraphicCircularView(
                ComplicationViewCircular(itemCount: itemCount))
        case .modularSmall:
            return CLKComplicationTemplateModularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!), line2TextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEM_NUMBER, itemCount: itemCount)))
        case .modularLarge:
            return CLKComplicationTemplateModularLargeStandardBody(headerImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!), headerTextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .STORE_NUMBER, itemCount: itemCount)), body1TextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEMS_LABEL, itemCount: itemCount)))
        case .utilitarianSmall:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEM_NUMBER, itemCount: itemCount)), imageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!))
        case .utilitarianSmallFlat:
            return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEM_NUMBER, itemCount: itemCount)), imageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!))
        case .utilitarianLarge:
            return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .STORE_NUMBER, itemCount: itemCount)), imageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!))
        case .circularSmall:
            return CLKComplicationTemplateCircularSmallStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!), line2TextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEM_NUMBER, itemCount: itemCount)))
        case .extraLarge:
            return CLKComplicationTemplateExtraLargeStackImage(line1ImageProvider: CLKImageProvider(onePieceImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!), line2TextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .STORE_NUMBER, itemCount: itemCount)))
        case .graphicCorner:
            return CLKComplicationTemplateGraphicCornerTextImage(textProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEM_NUMBER, itemCount: itemCount)), imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(systemName: itemCount > 0 ? "cart.badge.plus" : "cart")!))
        case .graphicBezel:
            return nil
        case .graphicRectangular:
            return CLKComplicationTemplateGraphicRectangularStandardBody(headerImageProvider: nil, headerTextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .STORE_NUMBER, itemCount: itemCount)), body1TextProvider: CLKTextProvider(format: returnText(for: itemReturnable, textType: .ITEMS_LABEL, itemCount: itemCount)))
        case .graphicExtraLarge:
            return nil
        @unknown default:
            return nil
        }
    }

    func returnText(for item: ItemModel.ItemReturnable, textType: returnTextType, itemCount: Int) -> String {
        switch textType {
        case .ITEM_NUMBER:
            if itemCount == 1 {
                return("(1)")
            }
            else {
                return("(\(itemCount))")
            }
        case .STORE_NUMBER:
            if item.items.count == 1 {
                return("(1) \(item.storeName)")
            }
            else {
                return("(\(item.items.count)) \(item.storeName)")
            }
        case .ITEMS_LABEL:
            var returnString = ""
            for item in item.items.sorted(by: { $0.name.lowercased() < $1.name.lowercased() }) {
                returnString += " - \(item.name)\n"
                if returnString.numberOfOccurrencesOf(string: "-") > 1 {
                    break
                }
            }
            
            if returnString.isEmpty {
                return " - No Groceries"
            }
            else {
                return String((String(returnString.dropLast())))
            }
        }
    }
    
    enum returnTextType {
        case STORE_NUMBER
        case ITEMS_LABEL
        case ITEM_NUMBER
    }
    
}

public func refreshComplications() {
#if os(watchOS)
    let server = CLKComplicationServer.sharedInstance()
    if let complications = server.activeComplications {
        for complication in complications {
            // Call this method sparingly. If your existing complication data is still valid,
            // consider calling the extendTimeline(for:) method instead.
            server.reloadTimeline(for: complication)
        }
    }
#endif
}

extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}
