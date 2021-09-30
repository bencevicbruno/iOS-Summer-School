//
//  OptionalPersonImageVIew.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct OptionalPersonImageView: View {
    @Binding var image: UIImage?
    
    var body: some View {
        GeometryReader { geo in
            if image == nil {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: geo.size.width, height: geo.size.height)
                   
            } else {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    .padding()
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct OptionalPersonImageView_Previews: PreviewProvider {
    static var previews: some View {
        OptionalPersonImageView(image: .constant(UIImage(systemName: "pencil")!))
        OptionalPersonImageView(image: .constant(nil))
    }
}
