//
//  EditView.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import SwiftUI
import MapKit

struct EditAnnotationView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var annotation: MKPointAnnotation
    
    @State private var loadingState = LoadingState.loaded
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nearby…")) {
                    if loadingState == .loaded {
                        LoadedEditAnnotationView(pages: pages) { pageTapped in
                            annotation.title = pageTapped.title
                            annotation.subtitle = pageTapped.description
                            presentationMode.wrappedValue.dismiss()
                        }
                    } else if loadingState == .loading {
                        LoadingEditAnnotationView()
                    } else {
                        FailedEditAnnotationView(onTryAgain: fetchNearbyPlaces)
                    }
                }
            }
            .navigationBarTitle("Edit place")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear(perform: fetchNearbyPlaces)
        }
    }
}

extension EditAnnotationView {
    func fetchNearbyPlaces() {
        let wikiService = WikipediaService()
        
        wikiService.fetchCities(at: annotation.coordinate) { pages in
            DispatchQueue.main.async {
                self.pages = pages
                self.loadingState = .loaded
            }
        } onFail: { errorMessage in
            print(errorMessage)
            self.loadingState = .failed
        }
    }
}

struct EditAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        EditAnnotationView(annotation: MKPointAnnotation())
    }
}
