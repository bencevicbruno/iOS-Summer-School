//
//  FilteredListView.swift
//  Project #12 - CoreDataProject
//
//  Created by Bruno Benčević on 9/27/21.
//

import CoreData
import Foundation
import SwiftUI

struct FilteredListView<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
    
    init(predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate)
        self.content = content
    }
    
    // One more initializer that accepts enum keys for predicates, but that would be too much...
}

struct FilteredListView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredListView<Wizard, Text>(filterKey: "", filterValue: "", sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) {
            Text($0.name ?? "")
        }
    }
}
