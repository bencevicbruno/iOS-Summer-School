//
//  ViewController.swift
//  Challenge #10
//
//  Created by Bruno Benčević on 8/24/21.
//

import UIKit

class MemeMakerViewController: UIViewController {

    private lazy var memeMakerView = MemeMakerView()
    
    override func loadView() {
        self.view = memeMakerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Meme Maker 1.0"
        addCallbacks()
    }

    func addCallbacks() {
        memeMakerView.onImageTappedCallback = onImageTapped
        memeMakerView.generateImageCallback = generateImage
        memeMakerView.shareImageCallback = shareImage
    }
    
    func onImageTapped(imageView: UIImageView) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    func generateImage(image: UIImage, topText: String?, bottomText: String?) {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1024, height: 1024))
        
        let newImage = renderer.image { ctx in
            image.draw(in: CGRect(x: 0, y: 0, width: 1024, height: 1024))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attribs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 50),
                .foregroundColor: UIColor.black.cgColor,
                .backgroundColor: UIColor.white.cgColor,
                .paragraphStyle: paragraphStyle
            ]
            
            if let topText = topText {
                let string = NSAttributedString(string: topText, attributes: attribs)
                string.draw(with: CGRect(x: 0, y: 0, width: 1024, height: 100), options: .usesLineFragmentOrigin, context: nil)
            }
            
            if let bottomText = bottomText {
                let string = NSAttributedString(string: bottomText, attributes: attribs)
                string.draw(with: CGRect(x: 0, y: 924, width: 1024, height: 100), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        self.memeMakerView.setMemeImage(image: newImage)
    }
    
    func shareImage(image: UIImage) {
        guard let imageData = image.pngData() else { return }
        
        let activity = UIActivityViewController(activityItems: [imageData], applicationActivities: [])
        activity.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        self.present(activity, animated: true)
    }
}

extension MemeMakerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.dismiss(animated: true)
        
        self.memeMakerView.setMemeImage(image: image)
    }
}

