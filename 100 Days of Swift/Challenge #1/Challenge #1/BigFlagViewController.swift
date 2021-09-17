//
//  BigFlagViewController.swift
//  Challenge #1
//
//  Created by Bruno Benčević on 7/28/21.
//

import UIKit

class BigFlagViewController: UIViewController {
    
    @IBOutlet var flagImage: UIImageView!
    
    var country: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        self.title = ViewController.getCountryName(country!)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        flagImage.image = UIImage(named: country!)
        flagImage.layer.shadowColor = UIColor.darkGray.cgColor
        flagImage.layer.shadowOffset = CGSize(width: 4, height: 4)
        flagImage.layer.shadowOpacity = 0.5
        flagImage.layer.masksToBounds = false
    }
    
    @objc func shareTapped() {
        guard let image = flagImage.image?.jpegData(compressionQuality: 1.0) else {
            print("Unable to fetch image data")
            return
        }
        
        let viewController = UIActivityViewController(activityItems: [image, country!], applicationActivities: [])
        
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(viewController, animated: true)
    }
}
