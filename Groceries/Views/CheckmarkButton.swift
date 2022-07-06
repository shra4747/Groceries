//
//  CheckmarkButton.swift
//  Groceries
//
//  Created by Shravan Prasanth on 7/6/22.
//

import SwiftUI

struct CheckmarkButton: View {
    let id: String
    let size: CGFloat
    let callback: (String, Bool)->()
    
    init(
        id: String,
        size: CGFloat = 14,
        callback: @escaping (String, Bool)->()
    ) {
        self.id = id
        self.size = size
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                self.callback(self.id, self.isMarked)
            }
        }) {
            Image(systemName: self.isMarked ? "checkmark.circle" : "circle")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.black)
                .frame(width: self.size, height: self.size)
        }
        .foregroundColor(Color.black)
        .tint(Color.black)
    }
}
//
////MARK:- Checkbox View Controller*
//struct CustomCheckBox: View {
//    var body: some View {
//        HStack{
//            VStack(spacing: 20) {
//                CheckboxField(
//                    id: "pizza",
//                    size: 20,
//                    textSize: 14,
//                    callback: checkboxSelected
//                )
//                CheckboxField(
//                    id: "pasta",
//                    size: 14,
//                    textSize: 20,
//                    callback: checkboxSelected
//                )
//            }
//        }
//        .padding()
//    }
//
//    func checkboxSelected(id: String, isMarked: Bool) {
//        print("\(id) is marked: \(isMarked)")
//    }
//}
