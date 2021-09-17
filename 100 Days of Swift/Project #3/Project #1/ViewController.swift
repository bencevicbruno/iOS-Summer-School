//
//  ViewController.swift
//  Project #1
//
//  Created by Bruno Benčević on 7/26/21.
//

import UIKit

class ViewController: UITableViewController {

    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPictures()
        setupNavigationBar()
    }

    func loadPictures() {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let files = try! fileManager.contentsOfDirectory(atPath: path)
        
        for fileName in files {
            if fileName.hasPrefix("nssl") {
                pictures.append(fileName)
            }
        }
        
        pictures.sort()
    }
    
    func setupNavigationBar() {
        self.title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareApp))
    }
    
    @objc func shareApp() {
        let viewController = UIActivityViewController(activityItems: ["Yall, get this app quickly!"], applicationActivities: [])
        
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(viewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageTitle = "\(indexPath.row + 1) of \(pictures.count)"
            
            navigationController?.pushViewController(vc, animated: true);
        }
    }
}

