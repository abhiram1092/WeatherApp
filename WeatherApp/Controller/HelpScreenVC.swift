//
//  HelpScreenVC.swift
//  WeatherApp
//
//  Created by Abhiram Sarvadevabhatla on 24/06/21.
//

import UIKit
import WebKit

class HelpScreenVC: UIViewController {

    @IBOutlet weak var helpWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            guard let filePath = Bundle.main.path(forResource: "index", ofType: "html")
            else {
                print ("File reading error")
                return
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            helpWebView.loadHTMLString(contents as String, baseURL: baseUrl)
        }
        catch {
            print ("File HTML error")
        }
    }
    @IBAction func getStartedClicked(_ sender: Any) {
        let sharedDefaults = UserDefaults.standard
        sharedDefaults.setValue(true, forKey: "firstTimeLogin")
    }
    

}
