//
//  ContentView.swift
//  Challenge #7 - Conference
//
//  Created by Bruno Benčević on 9/29/21.
//

import SwiftUI

struct ContentView: View {
    @State var people = [Person]()
    
    @State private var showingAddPersonSheet = false
    
    let dataService = LocalDataService()
    
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
                            self.showingAddPersonSheet = true
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Conference")
            .sheet(isPresented: $showingAddPersonSheet, content: {
                AddPersonView(onAddPersonTapped: addNewPerson)
            })
        }
        .onAppear(perform: loadPeople)
    }
    
    func loadPeople() {
        dataService.loadData { loadedPeople in
            people = loadedPeople
        } onFail: { errorMessage in
            print(errorMessage)
        }
    }
    
    func addNewPerson(newPerson: Person) {
        people.append(newPerson)
        people.sort()
        
        dataService.saveData(people) { errorMessage in
            print(errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
