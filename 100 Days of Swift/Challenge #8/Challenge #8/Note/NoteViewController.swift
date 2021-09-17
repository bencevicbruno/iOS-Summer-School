//
//  NoteViewController.swift
//  Challenge #8
//
//  Created by Bruno Benčević on 8/18/21.
//

import UIKit

class NoteViewController: UIViewController {

    private lazy var noteView = NoteView()
    
    public var note: Note!
    
    override func loadView() {
        self.view = noteView
        noteView.setup(note: note)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        ]
    }
    
    @objc func goBack() {
        let currentNote = noteView.getEditedNote()
        
        DispatchQueue.global(qos: .background).async {
            
            if !currentNote.isEmpty() {
                currentNote.save()
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func shareNote() {
        let noteToShare = noteView.getEditedNote()
        
        let viewController = UIActivityViewController(activityItems: [noteToShare.toRawText()], applicationActivities: nil)
        viewController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
        
        present(viewController, animated: true)
    }
    
    @objc func deleteNote() {
        let noteToDelete = noteView.getEditedNote()
        
        if noteToDelete.isEmpty() {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        let fileName = "note_\(noteToDelete.title).json"
        
        let fileManager = FileManager.default
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        DispatchQueue.global(qos: .background).async {
            do {
                try fileManager.removeItem(at: path)
            } catch  {
                print("Failed to delete \(fileName) \(error)")
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
