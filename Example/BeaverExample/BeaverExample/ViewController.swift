//
//  ViewController.swift
//  BeaverExample
//
//  Created by Ravi Tripathi on 19/01/20.
//  Copyright © 2020 Ravi Tripathi. All rights reserved.
//

import UIKit
import Beaver

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var jsonDisplayTextField: UITextView!
    
    lazy var userModel: UserModel = {
        let model = UserModel()
        model.email = "steve.jobs@apple.com"
        model.name = "Steven Paul Jobs"
        model.nickName = "Steve"
        model.phoneNumber = "9283929283929"
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapStoreDetails(_ sender: UIButton) {
        userModel.store(to: .documents, withFileName: "Model") { (result) in
            if result.success {
                self.statusLabel.text = "The json file was saved in \(result.filePath)"
            } else {
                self.statusLabel.text = result.errorMessage
            }
        }
    }
    
    @IBAction func didTapFetchDetails(_ sender: Any) {
        userModel.retrieve(withFileName: "Model", from: .documents) { (result) in
            if result.success {
                self.statusLabel.text = "Retrieved JSON!"
                self.jsonDisplayTextField.text = result.data?.prettyPrintedJSONString as String?
            } else {
                self.statusLabel.text = result.errorMessage
            }
        }
    }
    
}



extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
