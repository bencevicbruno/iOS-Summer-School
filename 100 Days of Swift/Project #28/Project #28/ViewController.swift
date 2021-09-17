//
//  ViewController.swift
//  Project #28
//
//  Created by Bruno Benčević on 8/25/21.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    let MAIN_TITLE = "Nothin to see here :)"
    let MESSAGE_KEY = "SecretMessage"
    let PASS_KEY = "Password"
    
    @IBOutlet var secretText: UITextView!
    @IBOutlet var authenticateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KeychainWrapper.standard.set("pass123", forKey: PASS_KEY)
        
        self.title = MAIN_TITLE
        
        let center = NotificationCenter.default
        
        center.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        center.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secretText.contentInset = .zero
        } else {
            secretText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secretText.scrollIndicatorInsets = secretText.contentInset
        secretText.scrollRangeToVisible(secretText.selectedRange)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authError in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if success {
                        self.unlockSecretMessage()
                    } else {
                        let alert = UIAlertController(title: "Authentication failed", message: "Unable to verify your identity!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default))
                        
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Biometry unavailable", message: "Enter your password:", preferredStyle: .alert)
            alert.addTextField()
            alert.addAction(UIAlertAction(title: "Okay", style: .default) {
                [weak self] _ in
                
                guard let self = self else { return }
                guard let passwordIn = alert.textFields?[0].text else { return }
                
                if passwordIn == KeychainWrapper.standard.string(forKey: self.PASS_KEY)! {
                    self.unlockSecretMessage()
                } else {
                    self.dismiss(animated: true) {
                        let alertWrongPass = UIAlertController(title: "Password incorrect!", message: nil, preferredStyle: .alert)
                        alertWrongPass.addAction(UIAlertAction(title: "OK", style: .default))
                        
                        self.present(alertWrongPass, animated: true)
                    }
                }
                
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func doneWriting() {
        saveSecretMessage()
        self.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    func unlockSecretMessage() {
        secretText.isHidden = false
        authenticateButton.isHidden = true
        self.title = "Secret stuff!"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneWriting))
        
        secretText.text = KeychainWrapper.standard.string(forKey: MESSAGE_KEY) ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secretText.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secretText.text, forKey: MESSAGE_KEY)
        secretText.resignFirstResponder()
        secretText.isHidden = true
        authenticateButton.isHidden = false
        self.title = MAIN_TITLE
    }
}

