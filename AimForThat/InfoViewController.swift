//
//  InfoViewController.swift
//  AimForThat
//
//  Created by Tobias Ruano on 30/03/2019.
//  Copyright © 2019 Tobias Ruano. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            print(url)
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            if let htmlData = try? Data(contentsOf: url) {
                webView.load(htmlData, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: baseURL)
            }
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }

}
