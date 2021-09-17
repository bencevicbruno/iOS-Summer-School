//
//  ViewController.swift
//  Challenge #1
//
//  Created by Bruno Benčević on 7/28/21.
//

import UIKit

class ViewController: UITableViewController {

    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Country Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadCountries()    }

    func loadCountries() {
        let fileManager = FileManager.default
        let path = Bundle.main.resourcePath!
        
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        items.filter({$0.hasSuffix(".png")})
            .forEach({countries.append($0)})
        
        countries.sort()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryFlag", for: indexPath)
        
        cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let country = countries[indexPath.row]
        cell.imageView?.image = UIImage(named: country)
        cell.imageView?.layer.borderWidth = 2
        cell.imageView?.layer.borderColor = UIColor.lightGray.cgColor
        cell.textLabel?.text = ViewController.getCountryName(country)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let bigFlagVC = storyboard?.instantiateViewController(identifier: "BigFlagVC") as? BigFlagViewController {
            bigFlagVC.country = countries[indexPath.row]
            
            navigationController?.pushViewController(bigFlagVC, animated: true)
        }
    }
    
    static func getCountryName(_ name: String) -> String {
        return String(name.split(separator: ".")[0]).capitalized
    }
}

