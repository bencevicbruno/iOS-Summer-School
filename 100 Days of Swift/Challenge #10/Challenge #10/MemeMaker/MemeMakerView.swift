//
//  MemeMakerView.swift
//  Challenge #10
//
//  Created by Bruno Benčević on 8/24/21.
//

import UIKit

class MemeMakerView: UIView {

    private lazy var topText = UITextField()
    private lazy var memeImage = UIImageView()
    private lazy var bottomText = UITextField()
    private lazy var generateButton = UIButton()
    private lazy var shareButton = UIButton()
    
    var onImageTappedCallback: ((UIImageView) -> Void)?
    var generateImageCallback: ((UIImage, String?, String?) -> Void)?
    var shareImageCallback: ((UIImage) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTapped))
        
        self.backgroundColor = .white
        
        topText.translatesAutoresizingMaskIntoConstraints = false
        topText.placeholder = "Insert top text here..."
        topText.textColor = .black
        topText.textAlignment = .center
        topText.layer.cornerRadius = 10
        topText.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        topText.autocorrectionType = .no
        self.addSubview(topText)
        
        memeImage.translatesAutoresizingMaskIntoConstraints = false
        memeImage.image = UIImage(named: "add")
        memeImage.layer.cornerRadius = 10
        memeImage.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        memeImage.isUserInteractionEnabled = true
        memeImage.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(memeImage)
        
        bottomText.translatesAutoresizingMaskIntoConstraints = false
        bottomText.placeholder = "Insert bottom text here..."
        bottomText.textColor = .black
        bottomText.textAlignment = .center
        bottomText.layer.cornerRadius = 10
        bottomText.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        bottomText.autocorrectionType = .no
        self.addSubview(bottomText)
        
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        generateButton.setTitle("Geneate", for: .normal)
        generateButton.layer.backgroundColor = UIColor.blue.withAlphaComponent(0.7).cgColor
        generateButton.layer.cornerRadius = 7
        generateButton.addTarget(self, action: #selector(generateImage), for: .touchUpInside)
        self.addSubview(generateButton)
        
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle("Share", for: .normal)
        shareButton.layer.backgroundColor = UIColor.blue.withAlphaComponent(0.7).cgColor
        shareButton.layer.cornerRadius = 7
        shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        self.addSubview(shareButton)
    }
    
    private func setupConstraints() {
        let space: CGFloat = 10
        let minHeight: CGFloat = 40
        
        NSLayoutConstraint.activate([
            topText.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            topText.heightAnchor.constraint(equalToConstant: minHeight),
            topText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            topText.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 2 * space),
            
            memeImage.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            memeImage.heightAnchor.constraint(equalTo: memeImage.widthAnchor),
            memeImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            memeImage.topAnchor.constraint(equalTo: topText.bottomAnchor, constant: space),

            bottomText.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            bottomText.heightAnchor.constraint(equalToConstant: minHeight),
            bottomText.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            bottomText.topAnchor.constraint(equalTo: memeImage.bottomAnchor, constant: space),

            generateButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            generateButton.heightAnchor.constraint(equalToConstant: minHeight),
            generateButton.topAnchor.constraint(equalTo: bottomText.bottomAnchor, constant: space),
            generateButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: -10),

            shareButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            shareButton.heightAnchor.constraint(equalToConstant: minHeight),
            shareButton.topAnchor.constraint(equalTo: bottomText.bottomAnchor, constant: space),
            shareButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor, constant: 10),

        ])
    }
    
    @objc func onImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if let tappedImageView = tapGestureRecognizer.view as? UIImageView {
            self.onImageTappedCallback?(tappedImageView)
        }
    }
    
    @objc func generateImage() {
        self.generateImageCallback?(memeImage.image!, topText.text, bottomText.text)
    }
    
    @objc func shareImage() {
        self.shareImageCallback?(memeImage.image!)
    }
    
    public func setMemeImage(image: UIImage) {
        self.memeImage.image = image
        self.memeImage.contentMode = .scaleAspectFit
    }
}
