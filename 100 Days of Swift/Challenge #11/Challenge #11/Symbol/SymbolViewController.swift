//
//  SymbolViewController.swift
//  Challenge #11
//
//  Created by Bruno Benčević on 8/27/21.
//

import UIKit

class SymbolViewController: UITableViewController {

    var symbols = [String]()
    var names = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SymbolCell")

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSymbol))
        
        GameData.symbols.forEach {
            symbols.append($0.value)
            names.append($0.key)
        }
        self.tableView.reloadData()
    }
    
    @objc func addSymbol() {
        let alert = UIAlertController(title: "Insert new symbol and its name:", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let symbol = alert.textFields?[0].text else { return }
            guard let name = alert.textFields?[1].text else { return }
            
            if let error = GameData.addSymbol(name: name, emoji: symbol) {
                let newAlert = UIAlertController(title: "Unable to add symbol!", message: error, preferredStyle: .alert)
                newAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self?.dismiss(animated: true) {
                    self?.present(newAlert, animated: true)
                }
            } else {
                self?.symbols.append(symbol)
                self?.names.append(name)
                self?.tableView.reloadData()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbols.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolCell", for: indexPath)

        cell.textLabel?.text = "\(symbols[indexPath.row]): \(names[indexPath.row])"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let alert = UIAlertController(title: "Edit: \(symbols[index])", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            if let error = GameData.removeSymbol(name: (self?.names[index])!) {
                let newAlert = UIAlertController(title: "Unable to delete symbol!", message: error, preferredStyle: .alert)
                newAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
                
                self?.dismiss(animated: true) {
                    self?.present(newAlert, animated: true)
                }
            }

            self?.symbols.remove(at: index)
            self?.names.remove(at: index)
            self?.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
}
