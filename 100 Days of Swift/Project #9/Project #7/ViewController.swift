import UIKit

class ViewController: UITableViewController {

    var allPetitions = [Petition]()
    var shownPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadData), with: nil)
        
        loadData()
        setupNavigationItems()
    }
    
    @objc func loadData() {
        DispatchQueue.global(qos: .).async {
            [weak self] in
            
            let urlString: String
            if self?.navigationController?.tabBarItem.tag == 0 {
                urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
            } else {
                urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            }
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self?.parse(json: data)
                } else {
                    self?.showError(title: "Connection Error", message: "Unable to reach www.hackingwithswift.com!")
                }
            } else {
                self?.showError(title: "Malformed URL", message: "Check the entered URL and try again!")
            }
        }
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            self.tableView.performSelector(onMainThread: #selector(showAllPetitions), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
            showError(title: "Error parsing JSON", message: "JSON file is malformed")
        }
    }
    
    @objc func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true)
    }
    
    func setupNavigationItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(filterPetitions)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.showAllPetitions))]
    }
    
    @objc func showCredits() {
        let alert = UIAlertController(title: "Credits", message: "Special thanks to the Whitehouse for providing the We The People API.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    @objc func filterPetitions() {
        let alert = UIAlertController(title: "Filter Petitions", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Filter", style: .default) {
            [weak self] _ in
            guard let keyword = alert.textFields?[0].text?.lowercased() else { return }
            
            print("prefilter")
            self!.shownPetitions = self!.allPetitions.filter({
                $0.title.lowercased().contains(keyword)
            })
            self!.tableView.reloadData()
            
            print("data filtered using \(keyword)")
        })
        
        present(alert, animated: true)
    }
    
    @objc func showAllPetitions() {
        shownPetitions = allPetitions
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petition = shownPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        
        viewController.detailItem = shownPetitions[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
