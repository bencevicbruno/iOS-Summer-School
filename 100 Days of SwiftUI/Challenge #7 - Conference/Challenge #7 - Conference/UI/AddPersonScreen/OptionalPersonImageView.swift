//
//  OptionalPersonImageVIew.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct OptionalPersonImageView: View {
    @State var image: UIImage?
    
    var body: some View {
        if image == nil {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .padding()
        } else {
            Image(uiImage: image!)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
        }
    }
}

struct OptionalPersonImageView_Previews: PreviewProvider {
    static var previews: some View {
        OptionalPersonImageView()
        OptionalPersonImageView(image: UIImage(systemName: "pencil"))
    }
}
