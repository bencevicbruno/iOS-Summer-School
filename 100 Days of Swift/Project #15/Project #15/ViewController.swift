import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
        //UIView.animate(withDuration: 1, delay: 0, options: []) {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
                break
            case 1:
                self.imageView.transform = .identity
                break
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                break
            case 3:
                self.imageView.transform = .identity
                break
            case 4: self.imageView.transform = CGAffineTransform(rotationAngle: 355)
                break
            case 5: self.imageView.transform = .identity
                break
            case 6:
                self.imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.5).translatedBy(x: 350, y: 60)
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            default:
                break
            }
        } completion: { finished in
            sender.isHidden = false
        }

        
        
        currentAnimation += 1
        currentAnimation %= 7
    }
}

