//
//  ViewController.swift
//  Challenge #11
//
//  Created by Bruno Benčević on 8/27/21.
//

import UIKit

class GameViewController: UIViewController {

    private lazy var gameView = GameView()
    
    override func loadView() {
        GameData.initialize()
        self.view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.gameView.victoryClosure = showVictoryAlert
    }
    
    private func setupNavigationBar() {
        self.title = "Memory Cards Game"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(modifySymbols))
    }
    
    @objc func restart() {
        let alert = UIAlertController(title: "Are you sure you want to restart the game?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { [weak self] _ in
            self?.gameView.setup()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc func modifySymbols() {
        let symbolVC = SymbolViewController()
        
        self.navigationController?.pushViewController(symbolVC, animated: true)
    }
    
    func showVictoryAlert() {
        let alert = UIAlertController(title: "You won!", message: "Congratulations!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.gameView.setup()
        })
        
        self.present(alert, animated: true)
    }
}
