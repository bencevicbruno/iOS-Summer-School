//
//  ViewController.swift
//  Challenge #2
//
//  Created by Bruno Benčević on 8/3/21.
//

import UIKit

class ShoppingListViewController: UITableViewController {

    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        self.navigationItem.leftBarButtonItems = [ UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItems)),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareList))]
        
        self.navigationItem.title = "Shopping List"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListItem", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        return cell;
    }
    
    @objc func addItem() {
        let alert = UIAlertController(title: "Insert item", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let actionAdd = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak alert] _ in
            
            if let item = alert?.textFields?[0].text?.lowercased() {
                self?.items.insert(item, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
                
            }
        }
        
        alert.addAction(actionAdd)
        
        present(alert, animated: true)
    }
    
    @objc func removeItems() {
        let alert = UIAlertController(title: "Are you sure you want to clear your shopping list?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {
            [weak self] _ in
                
            self?.items.removeAll()
            self?.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
    
    @objc func shareList() {
        let items = items.joined(separator: "\n")
        
        let viewController = UIActivityViewController(activityItems: [items], applicationActivities: nil)
        viewController.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
        
        present(viewController, animated: true)
    }
}
