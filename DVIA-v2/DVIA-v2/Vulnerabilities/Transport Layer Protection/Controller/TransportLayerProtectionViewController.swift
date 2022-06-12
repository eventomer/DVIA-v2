//
//  TransportLayerProtectionViewController.swift
//  DVIA - Damn Vulnerable iOS App (damnvulnerableiosapp.com)
//  Created by Prateek Gianchandani on 02/12/17.
//  Copyright © 2018 HighAltitudeHacks. All rights reserved.
//  You are free to use this app for commercial or non-commercial purposes
//  You are also allowed to use this in trainings
//  However, if you benefit from this project and want to make a contribution, please consider making a donation to The Juniper Fund (www.thejuniperfund.org/)
//  The Juniper fund is focusing on Nepali workers involved with climbing and expedition support in the high mountains of Nepal. When a high altitude worker has an accident (death or debilitating injury), the impact to the family is huge. The juniper fund provides funds to the affected families and help them set up a sustainable business.
//  For more information,  visit www.thejuniperfund.org
//  Or watch this video https://www.youtube.com/watch?v=HsV6jaA5J2I
//  And this https://www.youtube.com/watch?v=6dHXcoF590E
 


import UIKit
import Foundation

class TransportLayerProtectionViewController: UIViewController {

    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var CVVTextField: UITextField!
    @IBOutlet var nameOnCardTextField: UITextField!
    
    //As per Apr 11, 2018 for example.com
    let pinnedPublicKeyHash = "xmvvalwaPni4IBbhPzFPPMX6JbHlKqua257FmJsWWto="
    
    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(bytes: rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    var isSSLPinning: Bool = true
    var isPublicKeyPinning: Bool = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOnCardTextField.delegate = self
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "menu.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(menuTapped(_:)), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Network Layer Security"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.title = " "
    }
    
    @IBAction func checkATS(_ sender: Any) {
        DVIAUtilities.showAlert(title: "App Transport Security", message: "ATS establishes best-practice policies for secure network communications. Check whether the app follows these best practices or whether it ignore them. Look at the info.plist file", viewController: self)
    }
    @IBAction func menuTapped(_ sender: Any) {
        mainViewController?.toogle()
    }
    
    @IBAction func readArticleTapped(_ sender: Any) {
        DVIAUtilities.loadWebView(withURL: UrlLinks.transportLayerArticle.url, viewController: self)
    }
    
    @IBAction func sendOverHTTPTapped(_ sender: Any) {
        guard let url = URL(string: "http://example.com?http=1") else { return }
        isSSLPinning = false
        isPublicKeyPinning = false
        sendRequestOverUrl(url, sender: sender)
    }
 
    @IBAction func sendOverHTTPSTapped(_ sender: Any) {
        isSSLPinning = false
        isPublicKeyPinning = false
        guard let url = URL(string: "https://example.com?https=1") else { return }
        sendRequestOverUrl(url, sender: sender)
    }
    
    func sendRequestOverUrl(_ url: URL, sender: Any) {
        guard let sender = sender as? UIButton else { return }
        if cardNumberTextField.text?.isEmpty ?? true || nameOnCardTextField.text?.isEmpty ?? true || CVVTextField.text?.isEmpty ?? true {
            DVIAUtilities.showAlert(title: "Error", message: "One or more input fields is empty.", viewController: self)
            return
        }
        if(!Reachability.isConnectedToNetwork()){
            DVIAUtilities.showAlert(title: "Error", message: "Make sure you are connected to the internet.", viewController: self)
            return
        }
        var request = URLRequest(url: url.standardized)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postDictionary = [
            "card_number" : cardNumberTextField.text,
            "card_name" : nameOnCardTextField.text,
            "card_cvv" : CVVTextField.text
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: postDictionary, options: .prettyPrinted)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let delegate: URLSessionDelegate? = isSSLPinning || isPublicKeyPinning ? self : nil
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: .main)
        sender.isEnabled = false
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { sender.isEnabled = true }
            self.isSSLPinning = false
            self.isPublicKeyPinning = false
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                DispatchQueue.main.async { DVIAUtilities.showAlert(title: "", message: "Certificate validation failed. You will have to do better than this!!", viewController: self) }
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                DispatchQueue.main.async { DVIAUtilities.showAlert(title: "", message: "statusCode should be 200, but is \(httpStatus.statusCode)", viewController: self) }
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString) )")
            DispatchQueue.main.async { DVIAUtilities.showAlert(title: "", message: "Success!", viewController: self) }
        }
        task.resume()
    }
}

extension TransportLayerProtectionViewController: UITextFieldDelegate, NSURLConnectionDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func send(usingSSLPinning sender: Any) {
        isSSLPinning = true
        isPublicKeyPinning = false
        sendRequestOverUrl(URL(string: "https://example.com?ssl-pinning=1")!, sender: sender)
    }
    
    @IBAction func send(usingPublicKeyPinning sender: Any) {
        isSSLPinning = false
        isPublicKeyPinning = true
        sendRequestOverUrl(URL(string: "https://example.com?public-key=1")!, sender: sender)
    }
    
    @objc public func verifySSLPinning(challenge: URLAuthenticationChallenge) -> Bool {
        //Don't check for valid certificate when the user taps on "Send over HTTPs"
        guard let serverTrust = challenge.protectionSpace.serverTrust else { return false }
        guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else { return false }
        let remoteCertificateData: NSData = SecCertificateCopyData(certificate)
        if isSSLPinning {
            isSSLPinning = false
            guard let serverTrust = challenge.protectionSpace.serverTrust else { return false }
            guard let path = Bundle.main.path(forResource: "example", ofType: "der") else { return false }
            guard let skabberCertificateData = NSData(contentsOfFile: path) else { return false }
            if remoteCertificateData == skabberCertificateData {
                let credential = URLCredential(trust: serverTrust)
                challenge.sender?.use(credential, for: challenge)
                return true
            } else {
                challenge.sender?.cancel(challenge)
                return false
            }
        }
        
        //Don't check for valid public key when the user taps on "Send over HTTPs"
        if isPublicKeyPinning && !isSSLPinning {
            isPublicKeyPinning = false
            if let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) {
                // Public key pinning
                let serverPublicKey = SecCertificateCopyKey(serverCertificate)
                let serverPublicKeyData:NSData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!
                let keyHash = sha256(data: serverPublicKeyData as Data)
                if (keyHash == pinnedPublicKeyHash) {
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return true
                }else{
                    challenge.sender?.cancel(challenge)
                    return false
                }
            }
            
        }
        let credential = URLCredential(trust: serverTrust)
        challenge.sender?.use(credential, for: challenge)
        return true
    }
}

extension TransportLayerProtectionViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if !verifySSLPinning(challenge: challenge) {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
