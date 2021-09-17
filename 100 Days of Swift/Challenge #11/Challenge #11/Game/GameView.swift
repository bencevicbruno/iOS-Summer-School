//
//  GameView.swift
//  Challenge #11
//
//  Created by Bruno Benčević on 8/27/21.
//

import UIKit

class GameView: UIView {
    
    let ROWS = 5, COLUMNS = 4
    
    private lazy var bottomCards = [UIButton]()
    private lazy var topCards = [UIButton]()
    
    private var gameDictionary = [String: String]()
    private var pairsLeft = 10
    
    private var firstCard: (String, Int)?
    
    var canTap = true
    
    var victoryClosure: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup() {
        bottomCards.forEach {
            $0.removeFromSuperview()
        }
        bottomCards.removeAll()
        topCards.forEach {
            $0.removeFromSuperview()
        }
        topCards.removeAll()
        setupCards(forTop: true)
        setupCards(forTop: false)
        setupCards()
    }
    
    private func setupCards(forTop: Bool) {
        let SMALL_SPACE: CGFloat = 10
        
        var lastColumnButton: UIButton?
        
        for row in 0 ..< ROWS {
            var lastRowButton: UIButton?
            
            for column in 0 ..< COLUMNS {
                let index = row * COLUMNS + column
                
                // SETUP
                let cardButton = UIButton()
                cardButton.tag = index
                cardButton.isHidden = !forTop
                cardButton.translatesAutoresizingMaskIntoConstraints = false
                cardButton.addTarget(self, action: #selector(onCardTap(_:)), for: .touchUpInside)
                
                // LAYER
                let layer = cardButton.layer
                layer.backgroundColor = forTop ? UIColor.random().cgColor : topCards[index].layer.backgroundColor
                layer.cornerRadius = 10
                layer.borderWidth = 5
                layer.borderColor = UIColor.white.cgColor
                
                // FINISHING UP
                self.addSubview(cardButton)
                if forTop { topCards.append(cardButton) } else { bottomCards.append(cardButton) }
                
                // SIZE CONSTRAINTS
                cardButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 1.0 / CGFloat(COLUMNS), constant: -SMALL_SPACE).isActive = true
                cardButton.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor, multiplier: 1.0 / CGFloat(ROWS), constant: -SMALL_SPACE).isActive = true
                
                // ROW-ALIGN CONSTRAINTS
                if lastRowButton == nil {
                    cardButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: SMALL_SPACE / 2).isActive = true
                } else {
                    cardButton.leftAnchor.constraint(equalTo: lastRowButton!.rightAnchor, constant: SMALL_SPACE).isActive = true
                }
                lastRowButton = cardButton
                
                // COLUMN-ALIGN CONSTRAINTS
                if lastColumnButton == nil {
                    cardButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: SMALL_SPACE / 2).isActive = true
                } else {
                    cardButton.topAnchor.constraint(equalTo: lastColumnButton!.bottomAnchor, constant: SMALL_SPACE).isActive = true
                }
                
                if column == COLUMNS - 1 {
                    lastColumnButton = cardButton
                }
            }
            
            lastRowButton = nil
        }
    }
    
    @objc private func onCardTap(_ button: UIButton) {
        if !canTap { return }
        let index = button.tag
        let bottomCard = bottomCards[index]
        let topCard = topCards[index]
        
        bottomCard.isHidden.toggle()
        topCard.isHidden.toggle()
        
        if bottomCard.isHidden {
            firstCard = nil
            return
        }
        
        if firstCard == nil {
            firstCard = (bottomCard.title(for: .normal)!, index)
        } else {
            let secondCard = bottomCard.title(for: .normal)!
            canTap = false
            
            if doPairsMatch(secondCard: secondCard) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    bottomCard.isHidden = true
                    topCard.isHidden = true
                    
                    self.bottomCards[self.firstCard!.1].isHidden = true
                    self.topCards[self.firstCard!.1].isHidden = true
                    self.firstCard = nil
                    self.canTap = true
                    
                    self.pairsLeft -= 1
                    
                    if self.pairsLeft == 0 {
                        self.victoryClosure?()
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    bottomCard.isHidden = true
                    topCard.isHidden = false
                    
                    self.bottomCards[self.firstCard!.1].isHidden = true
                    self.topCards[self.firstCard!.1].isHidden = false
                    self.firstCard = nil
                    self.canTap = true
                }
                
                
                
            }
        }
    }
    
    private func removeCard(index: Int) {
        bottomCards.removeAll {
            $0.tag == index
        }
        
        topCards.removeAll {
            $0.tag == index
        }
    }
    
    private func setupCards() {
        pairsLeft = 10
        gameDictionary = GameData.getSymbolsForAGame()
        
        var allValues = [String]()
        gameDictionary.forEach {
            allValues.append($0.key)
            allValues.append($0.value)
        }
        allValues.shuffle()
        
        for (index, button) in bottomCards.enumerated() {
            button.setTitle(allValues[index], for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel!.font = UIFont.boldSystemFont(ofSize: 20)
            button.titleLabel!.numberOfLines = 2
            button.titleLabel!.textAlignment = .center
            button.isHidden = true
        }
        
        topCards.forEach {
            $0.isHidden = false
        }
    }
    
    func doPairsMatch(secondCard: String) -> Bool {
        return gameDictionary[firstCard!.0] ?? "" == secondCard
            || gameDictionary[secondCard] ?? "" == firstCard!.0
    }
    
}
