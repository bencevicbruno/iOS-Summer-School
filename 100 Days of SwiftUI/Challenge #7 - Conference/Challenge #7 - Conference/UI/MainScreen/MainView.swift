//
//  ContentView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct ContentView: View {
    let people = [Person.test(), Person.test(), Person.test()]
    
    @State private var showingAddPersonSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(people) { person in
                        NavigationLink(
                            destination: PersonDetailView(person: person),
                            label: {
                                PersonCellView(person: person)
                            })
                    }
                }
                
                HStack(alignment: .bottom) {
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Spacer()
                        
                        PlusView {
                            print("Plus tapped")
                            self.showingAddPersonSheet = true
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Conference")
            .sheet(isPresented: $showingAddPersonSheet, content: {
                AddPersonView()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
