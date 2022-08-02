//
//  ViewController.swift
//  HW21-bruteForce
//
//  Created by Anatoliy on 30.07.2022.
//

import UIKit

class ViewController: UIViewController  {
    
    let lenghtPassword = 3
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var isBlack: Bool = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
            label.textColor = isBlack ? .white : .black
        }
    }
    
    @IBAction func changeBackground(_ sender: Any) {
        isBlack.toggle()
    }
    
    @IBAction func clearTextField(_ sender: Any) {
        
        label.text = ""
        textField.text = ""
        spiner.stopAnimating()
        passwordLabel.text = ""
    }
    
    @IBAction func showEye(_ sender: Any) {
        textField.isSecureTextEntry.toggle()
    }
    
    @IBAction func searchBut(_ sender: Any) {
        cancelButton.isHidden = true
        spiner.startAnimating()
        label.text = "Wait"
        bruteForce(passwordToUnlock: textField.text ?? "", completion: { [weak self] password in
            self?.cancelButton.isHidden = false
            self?.label.text = "Password found"
            self?.spiner.stopAnimating()
            self?.textField.isSecureTextEntry = false
            
        })
    }
    
    @IBAction func onBut(_ sender: Any) {
        generatePassword()
        textField.isSecureTextEntry = true
        label.text = "Password generated"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spiner.hidesWhenStopped = true
        textField.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        textField.delegate = self
    }
    
    func shouPassword(password: String) {
        passwordLabel.text = password
    }
    
    func generatePassword() {
        let passwordCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+=")
        let randomPassword = String((0..<lenghtPassword).map{ _ in passwordCharacters[Int(arc4random_uniform(UInt32(passwordCharacters.count)))]})
        textField.text = randomPassword
    }
    
    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void) {
        
        let queue = DispatchQueue(label: "OneQueue")
        
        queue.async {
            
            let allowedCharacters: [String] = String().printable.map { String($0) }
            var password: String = ""
    
            while password != passwordToUnlock {
                password = generateBruteForce(password, fromArray: allowedCharacters)
                DispatchQueue.main.async {
                    self.shouPassword(password: password)
                }
            }
            DispatchQueue.main.async {
                completion(password)
                
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        
        let subsStringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - subsStringToReplace.count + string.count
        return count <= 3
    }
}

