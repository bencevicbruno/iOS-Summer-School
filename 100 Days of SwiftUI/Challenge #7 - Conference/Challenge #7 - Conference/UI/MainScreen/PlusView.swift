//
//  PlusView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct PlusView: View {
    var onTapped: (() -> Void)?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
                .shadow(radius: 10)
            
            Text("+")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }.onTapGesture {
            self.onTapped?()
        }
    }
}

struct PlusView_Previews: PreviewProvider {
    static var previews: some View {
        PlusView()
    }
}
