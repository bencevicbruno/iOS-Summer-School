//
//  FailedEditAnnotationView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI

struct FailedEditAnnotationView: View {
    var onTryAgain: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Fetching data failed.")
            
            Button("Try again") {
                onTryAgain?()
            }
        }
    }
}

struct FailedEditAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        FailedEditAnnotationView()
    }
}
