//
//  ViewController.swift
//  Challenge #8
//
//  Created by Bruno Benčević on 8/18/21.
//

import UIKit

class NoteListViewController: UITableViewController {

    private var notes = [Note]()
    private var shownNotes = [Note]()
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = "Notes"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openNewNote))
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchNotes)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadData))
        ]
    }

    @objc func openNewNote() {
        openNote(Note(title: "", body: ""))
    }
    
    @objc func searchNotes() {
        let alert = UIAlertController(title: "Search notes", message: "Enter a keyword:", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Search", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            
            let keyword = alert.textFields?[0].text ?? ""
            if keyword == "" { return }
            
            self.shownNotes = self.notes.filter {$0.title.contains(keyword)}
            self.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc func reloadData() {
        DispatchQueue.global(qos: .background).async {
            [weak self] in
            guard let self = self else { return }
            
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            var newNotes = [Note]()
            
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                let names = fileURLs.filter {
                    $0.absoluteString.contains("note_")
                }.map { $0.absoluteString.substringAfter("note_").dropFirst(5).dropLast(5) }
                
                for name in names {
                    newNotes.append(Note.load(title: String(name)))
                }
                
            } catch {
                print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
            }
            
            self.notes = newNotes
            self.shownNotes = self.notes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: UITableViewController
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        
        let note = shownNotes[indexPath.row]
        
        cell.textLabel?.text = note.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openNote(shownNotes[indexPath.row])
    }
    
    private func openNote(_ note: Note) {
        if let viewController = self.storyboard?.instantiateViewController(identifier: "NoteViewController") as? NoteViewController {
            viewController.note = note
            
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            print("Failed to cast as NoteViewController")
        }
    }
}
