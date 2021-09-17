//
//  NoteView.swift
//  Challenge #8
//
//  Created by Bruno Benčević on 8/19/21.
//

import UIKit

class NoteView: UIView {

    private lazy var titleText = UITextView()
    private lazy var dateLabel = UILabel()
    private lazy var bodyText = UITextView()
    
    var note: Note?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setup(note: Note) {
        self.note = note
        setupView()
        setupConstraints()
        setupObservers()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        titleText.text = note!.title
        titleText.font = UIFont.boldSystemFont(ofSize: 20)
        titleText.textContainer.maximumNumberOfLines = 1
        titleText.isScrollEnabled = false
        titleText.textContainerInset = .zero
        titleText.textContainer.lineFragmentPadding = .zero
        self.addSubview(titleText)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.text = note!.getDateDetails()
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = UIColor.gray
        self.addSubview(dateLabel)
        
        bodyText.translatesAutoresizingMaskIntoConstraints = false
        bodyText.text = note!.body
        bodyText.font = UIFont.systemFont(ofSize: 20)
        bodyText.textContainer.lineFragmentPadding = .zero
        self.addSubview(bodyText)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleText.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            titleText.heightAnchor.constraint(equalToConstant: 20),
            titleText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 5),
            dateLabel.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95),
            dateLabel.heightAnchor.constraint(equalToConstant: 10),
            dateLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            bodyText.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            bodyText.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95),
            bodyText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bodyText.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func setupObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustTextViewForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustTextViewForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustTextViewForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            bodyText.contentInset = .zero
        } else {
            bodyText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - self.safeAreaInsets.bottom, right: 0)
        }
        
        bodyText.scrollIndicatorInsets = bodyText.contentInset
        bodyText.scrollRangeToVisible(bodyText.selectedRange)
    }
    
    public func getEditedNote() -> Note {
        return Note(title: titleText.text, body: bodyText.text)
    }
}
