import UIKit

class ViewController: UITableViewController {

    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItem()
        loadWords()
        startGame()
    }
    
    /* Setup */
    
    func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
    }
    
    func loadWords() {
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let words = try? String(contentsOf: url) {
                allWords = words.components(separatedBy: "\n")
            }
        }
        else {
            let alertController = UIAlertController(title: "Critical Error", message: "Unable to load words!", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: {_ in exit(-1)}))
            
            present(alertController, animated: true)
        }
    }
    
     func startGame() {
        self.title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        self.tableView.reloadData()
    }
    
    /* TableView Setup */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        
        return cell
    }
    
    /* NavigationItem Functionality */
    
    @objc func promptForAnswer() {
        let alertController = UIAlertController(title: "Enter aswer", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak alertController] _ in
            
            guard let answer = alertController?.textFields?[0].text?.lowercased() else { return }
            
            self?.submit(answer)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    @objc func restartGame() {
        let alertController = UIAlertController(title: "Restart?", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .destructive,
                                                handler: {[weak self] _ in self?.startGame()}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alertController, animated: true)
    }
    
    /* Submit Functionality */
    
    func submit(_ answer: String) {
        var errorTitle = ""
        var errorMessage = ""
        
        if isPossible(word: answer, &errorTitle, &errorMessage)
        && isOriginal(word: answer, &errorTitle, &errorMessage)
        && isReal(word: answer, &errorTitle, &errorMessage)
        && isLongEnough(word: answer, &errorTitle, &errorMessage)
        && isDifferent(word: answer, &errorTitle, &errorMessage) {
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            return
        }
        
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func isPossible(word: String, _ errorTitle: inout String, _ errorMessage: inout String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            }
            else {
                errorMessage = "Word not possible"
                errorTitle = "How on Earth can you spell \(word) out of \(self.title!)?"
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String, _ errorTitle: inout String, _ errorMessage: inout String) -> Bool {
        if !usedWords.contains(word) {
            return true
        }
        
        errorTitle = "Word already used"
        errorMessage = "Come on, think of something else!"
        
        return false
    }
    
    func isReal(word: String, _ errorTitle: inout String, _ errorMessage: inout String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        if misspelledRange.location != NSNotFound {
            errorTitle = "Word not recognized"
            errorMessage = "You can't just make up words, buddy!"
            return false
        }
        
        return true
    }
    
    func isLongEnough(word: String, _ errorTitle: inout String, _ errorMessage: inout String) -> Bool {
        if word.count > 3 {
            return true
        }
        
        errorTitle = "Word is too short"
        errorMessage = "Amigo, you gotta be more creative!"
        
        return false
    }
    
    func isDifferent(word: String, _ errorTitle: inout String, _ errorMessage: inout String) -> Bool {
        if word != self.title! {
            return true
        }
        
        errorTitle = "Word is not different"
        errorMessage = "Mein Freund, be original!"
        
        return false
    }
}
