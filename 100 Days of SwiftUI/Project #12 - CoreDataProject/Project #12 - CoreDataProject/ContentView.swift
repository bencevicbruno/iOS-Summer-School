//
//  ContentView.swift
//  Project #12 - CoreDataProject
//
//  Created by Bruno Benčević on 9/26/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    @State private var firstLetter = ""
    
    var body: some View {
        FilteredListView(filterKey: "name", filterValue: firstLetter, sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) { (wizard: Wizard) in
            Text("\(wizard.name ?? "Unknown name")")
        }
        
        Button("Add Examples") {
            let taylor = Wizard(context: self.moc)
            taylor.name = "Taylor"
            
            let ed = Wizard(context: self.moc)
            ed.name = "Ed"
            
            let adele = Wizard(context: self.moc)
            adele.name = "Adele"
            
            let harry = Wizard(context: self.moc)
            harry.name = "Harry"
            
            try? self.moc.save()
        }
        
        Button("Show A") {
            self.firstLetter = "H"
        }
        
        Button("Show S") {
            self.firstLetter = "A"
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
