//
//  LocationMarkerView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI

struct LocationMarkerView: View {
    var body: some View {
        Text("+")
            .font(Font.system(size: 60))
            .fontWeight(.medium)
            .foregroundColor(Color.blue)
            .opacity(0.5)
    }
}

struct LocationMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMarkerView()
    }
}
