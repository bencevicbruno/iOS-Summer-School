//
//  AddBookView.swift
//  Project #11 - Bookworm
//
//  Created by Bruno Benčević on 9/26/21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    @State private var datePublished = Date.distantPast
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    DatePicker("Published date", selection: $datePublished, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.datePublished = self.datePublished
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isBookValid)
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
    
    var isBookValid: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !genre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
