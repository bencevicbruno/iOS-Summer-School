//
//  LoadedEditAnnotationView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI

struct LoadedEditAnnotationView: View {
    var pages: [Page]
    var onTapped: ((Page) -> Void)?
    
    var body: some View {
        List(pages, id: \.pageid) { page in
            VStack(alignment: .leading) {
                Text("\(page.title)")
                    .font(.headline)
                Text(page.description)
                    .italic()
            }
            .onTapGesture {
                onTapped?(page)
            }
        }
    }
}

struct LoadedEditAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LoadedEditAnnotationView(pages: [])
    }
}
