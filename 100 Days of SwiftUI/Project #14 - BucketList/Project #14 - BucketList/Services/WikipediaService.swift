//
//  WikipediaService.swift
//  Project #14 - BucketList
//
//  Created by Bruno Benčević on 9/28/21.
//

import Foundation
import CoreLocation

class WikipediaService {
    
    func fetchCities(at coordinate: CLLocationCoordinate2D, onSucces: @escaping ([Page]) -> Void, onFail: @escaping (String) -> Void) {
        let url = getURL(coordinate: coordinate)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                if let items = try? decoder.decode(Result.self, from: data) {
                    let pages = Array(items.query.pages.values).sorted()
                    onSucces(pages)
                } else {
                    onFail("Parsing data from JSON failed!")
                }
            } else {
                onFail("Wikipedia fetch request failed!")
            }
        }.resume()
    }
    
    private func getURL(coordinate: CLLocationCoordinate2D) -> URL {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(coordinate.latitude)%7C\(coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        return URL(string: urlString)!
    }
}

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
}
