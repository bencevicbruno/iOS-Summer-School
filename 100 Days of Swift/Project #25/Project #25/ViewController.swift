//
//  ViewController.swift
//  Project #25
//
//  Created by Bruno Benčević on 8/23/21.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController {

    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var session: MCSession?
    //var advertiserAssistant: MCAdvertiserAssistant? - fix below
    var advertiserAssistant: MCNearbyServiceAdvertiser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Multipeer Tests"
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
            UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showConnectedPeers))
        ]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
    }
    
    @objc func showConnectionPrompt() {
        let alert = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        alert.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    @objc func showConnectedPeers() {
        guard let session = session else { return }
        
        let alert = UIAlertController(title: "Connected peers:", message: nil, preferredStyle: .actionSheet)
        
        for peer in session.connectedPeers {
            alert.addAction(UIAlertAction(title: peer.displayName, style: .default, handler: nil))
        }
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        advertiserAssistant = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let session = session else { return }
        
        let browser = MCBrowserViewController(serviceType: "hws-project25", session: session)
        browser.delegate = self
        
        self.present(browser, animated: true)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        cell.layer.backgroundColor = UIColor.red.cgColor
        cell.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cell.widthAnchor.constraint(equalToConstant: 145),
            cell.heightAnchor.constraint(equalToConstant: 145)
        ])
        
        return cell
    }
}

extension ViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let session = session else { return }
        
        if session.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                    try session.send(Data("hehe iks de".utf8), toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    let alert = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    
                    self.present(alert, animated: true)
                }
            }
        }
    }
}

extension ViewController : MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        var stateString = ""
        
        switch state {
        case .connected:
            stateString = "connected"
            break
        case .connecting:
            stateString = "connecting"
            break
        case .notConnected:
            stateString = "not connected"
            break
        default:
            stateString = "unknown"
        }
        
        print("[\(peerID.displayName)]: \(stateString)")
        
        if state == .notConnected {
            let alert = UIAlertController(title: "\(peerID.displayName) disconnected!", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .default))
            
            self.present(alert, animated: true)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            [weak self] in
            
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let text = String(decoding: data, as: UTF8.self)
                let alert = UIAlertController(title: "\(peerID.displayName) says", message: text, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self?.present(alert, animated: true)
            }
        }
    }
}

extension ViewController : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let alert = UIAlertController(title: "Project25", message: "\(peerID.displayName) wants to connect", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Accept", style: .default) {
            [weak self] _ in
            invitationHandler(true, self?.session)
        })
        alert.addAction(UIAlertAction(title: "Decline", style: .cancel) {
            _ in
            invitationHandler(false, nil)
        })
        
        self.present(alert, animated: true)
    }
}
