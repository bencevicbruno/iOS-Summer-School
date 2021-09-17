//
//  ViewController.swift
//  Project2
//
//  Created by Bruno Benčević on 7/27/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var score = 0
    var correctAnswer = 0
    var totalGames = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        askQuestion()
    }
    
    func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startOver))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
    }
    
    @objc func startOver() {
        let alert = UIAlertController(title: "Start over?", message: "All progress will be lost", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Start over", style: .destructive) {
            [weak self] _ in
            
            self?.score = 0
            self?.correctAnswer = 0
            self?.totalGames = 0
            
            self?.askQuestion()
        })
        
        present(alert, animated: true)
    }
    
    @objc func showScore() {
        showAlert(title: "Ello there!", message: "Your score is \(score)", askNewQuestion: false)
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        if totalGames == 10 {
            showAlert(title: "Game finished!", message: "Total score: \(score)")
            score = 0
            correctAnswer = 0
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        setupButton(button1, countries[0])
        setupButton(button2, countries[1])
        setupButton(button3, countries[2])
        
        self.title = "\(countries[correctAnswer].uppercased()) (Score: \(score))"
        totalGames += 1
    }
    
    func setupButton(_ button: UIButton, _ name: String) {
        button.setImage(UIImage(named: name), for: .normal)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        }
        else {
            title = "Wrong!\nThat was \(countries[sender.tag])."
            score -= 1
        }
        
        showAlert(title: title, message: "Your score is \(score)")
    }
    
    func showAlert(title: String, message: String, askNewQuestion: Bool = true) {
        let actionController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actionController.addAction(UIAlertAction(title: "Continue",
                                                 style: .default,
                                                 handler: askNewQuestion ? askQuestion : nil))
        present(actionController, animated: true)
    }
}

