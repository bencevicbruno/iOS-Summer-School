import UIKit

class NavigationViewController: UITableViewController {

    public static var socialMediaList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSocialMediaList()
        self.title = "Social Media"
    }
    
    func loadSocialMediaList() {
        if let url = Bundle.main.url(forResource: "social_media", withExtension: "txt") {
            if let list = try? String(contentsOf: url) {
                NavigationViewController.socialMediaList = list.components(separatedBy: "\n").map({$0.capitalized})
                NavigationViewController.socialMediaList.remove(at: NavigationViewController.socialMediaList.count - 1) // remove last empty line...
            }
        }
        else {
            let alertController = UIAlertController(title: "Critical Error", message: "Unable to load social_media.txt!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: {_ in exit(-1)}))
            
            present(alertController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NavigationViewController.socialMediaList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialMediaCell", for: indexPath)
        cell.textLabel?.text = NavigationViewController.socialMediaList[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = cell.textLabel?.font.withSize(20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = storyboard?.instantiateViewController(identifier: "Webpage") as? WebpageViewController {
            
            viewController.website = "https://www." + NavigationViewController.socialMediaList[indexPath.row] + ".com"
            navigationController?.pushViewController(viewController, animated: true);
        }
    }

}
