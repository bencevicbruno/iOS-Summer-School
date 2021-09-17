import UIKit

class ViewController: UITableViewController {

    var allPetitions = [Petition]()
    var shownPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.performSelector(inBackground: #selector(setupData), with: nil)
        setupNavigationItems()
    }
    
    // MARK: Loading data
    
    @objc func setupData() {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        loadData(urlString: urlString)
    }
    
    func loadData(urlString: String) {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError(title: "Connection Error", message: "Unable to reach www.hackingwithswift.com!")
            }
        } else {
            showError(title: "Malformed URL", message: "Check the entered URL and try again!")
        }
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            allPetitions = jsonPetitions.results
            showAllPetitions()
        } else {
            showError(title: "Error parsing JSON", message: "JSON file is malformed")
        }
    }
    
    func setupNavigationItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(filterPetitions)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(showAllPetitions))]
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
            
            guard let this = self else { return }
            
            guard let keyword = alert.textFields?[0].text?.lowercased() else { return }
            
            DispatchQueue.global(qos: .background).async {
                this.shownPetitions = self!.allPetitions.filter({
                    $0.title.lowercased().contains(keyword)
                })
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            }
        })
        
        present(alert, animated: true)
    }
    
    @objc func showAllPetitions() {
        DispatchQueue.main.async {
            [weak self] in
            self?.shownPetitions = self!.allPetitions
            self?.tableView.reloadData()
        }
    }
    
    // MARK: TableView
    
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
    
    // MARK: Error hanlding
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            [weak self] in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) {
                _ in
                exit(-1)
            })
            
            self?.present(alertController, animated: true)
        }
    }
}
