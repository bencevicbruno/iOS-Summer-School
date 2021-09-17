import UIKit

extension UIColor {
    static func FromHex(_ hex: UInt32) -> UIColor {
        return UIColor(red: CGFloat(Float((hex >> 16) & 0xFF) / 255),
                       green: CGFloat(Float((hex >> 08) & 0xFF) / 255),
                       blue: CGFloat(Float((hex >> 00) & 0xFF) / 255),
                       alpha: CGFloat(1.0))
    }
}

class ViewController: UIViewController {

    var labels = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel(text: "label1", backgroundColor: UIColor.FromHex(0xBEEBEE))
        createLabel(text: "label2", backgroundColor: UIColor.FromHex(0xDECADE))
        createLabel(text: "label3", backgroundColor: UIColor.FromHex(0xC0FFEE))
        createLabel(text: "label4", backgroundColor: UIColor.FromHex(0xB00B1E))
        createLabel(text: "label5", backgroundColor: UIColor.FromHex(0xBADA55))
        
        addConstraints2()
    }
    
    func createLabel(text: String, backgroundColor: UIColor) {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = backgroundColor
        label.text = text
        label.textAlignment = .center
        label.sizeToFit()
        
        labels.append(label)
        self.view.addSubview(label)
    }
    
    // Example #1
    func addConstraintsA() {
        let metrics = ["labelHeight": 88]
        let views = labels.reduce(into: [String: UILabel]()) {
            labels, label in
            labels[label.text!] = label
        }
        
        views.forEach() {
            [weak self] (name, label) in
            self!.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(name)]|", options: [], metrics: nil, views: [name: label]))
        }
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: views))
    }

    // Example #2
    func addConstraintsB() {
        var previousLabel: UILabel?
        
        for label in labels {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            if let previousLabel = previousLabel {
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previousLabel = label
        }
    }
    
    // Challenge #1
    func addConstraints1() {
        var previousLabel: UILabel?
        
        for label in labels {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            if let previousLabel = previousLabel {
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            previousLabel = label
        }
    }
    
    // Challenge #2
    func addConstraints2() {
        var previousLabel: UILabel?
        
        for label in labels {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
            if let previousLabel = previousLabel {
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            previousLabel = label
        }
    }
}

