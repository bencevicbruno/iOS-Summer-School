//
//  UnlockButton.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI

struct UnlockButtonView: View {
    var text: String
    var onTapped: (() -> Void)?
    
    var body: some View {
        Button(text) {
            self.onTapped?()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}

struct UnlockButtonView_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButtonView(text: "Unlock")
    }
}
