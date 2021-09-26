//
//  SwiftUIView.swift
//  Project #11 - Bookworm
//
//  Created by Bruno Benčević on 9/26/21.
//

import SwiftUI
import CoreData

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        NavigationLink(destination: DetailView(book: book)) {
            HStack {
                EmojiRatingView(rating: book.rating)
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text(book.title ?? "Unknown Title")
                        .font(.headline)
                        .foregroundColor(book.rating == 1 ? Color.red : Color.black)
                    Text(book.author ?? "Unknown Author")
                        .foregroundColor(.secondary)
                }
                
                Text(getBookPublishedDate(book.datePublished))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func getBookPublishedDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        return "Date published: \(formatter.string(from: date ?? Date.distantPast))"
    }
}

struct BookRowView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."
        
        return BookRowView(book: book)
    }
}
