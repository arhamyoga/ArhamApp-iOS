//
//  ViewController.swift
//  ArhamYoga
//
//  Created by SRIJAN on 16/12/17.
//  Copyright © 2017 DRISHTI-IT. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class ArhamYogaViewController: UIViewController {

    fileprivate var activityIndicator: UIActivityIndicatorView!
    var webView: UIWebView!
    var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = Constants.PageTitle.viewPage
        Analytics.setScreenName(AnalyticsScreenName.defaultScreen, screenClass: AnalyticsScreenName.defaultScreen)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        setUpActivityIndicator()
        setUpWebView()
        setUpActivityIndicator()
        setUpNextButton()
    }
    
    // Set Up Activity Indicator
    private func setUpActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = view.center;
        self.view.addSubview(activityIndicator)
        
    }
    
    // Set Up Webview
    private func setUpWebView() {
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 64))
        webView.backgroundColor = UIColor.white
        webView.delegate = self
        webView.scrollView.bounces = true
        webView.scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(webView)
        loadHTML()
    }
    
    // Set Up Next Button
    private func setUpNextButton() {
        nextButton = UIButton(type: .roundedRect)
        nextButton.frame = CGRect(x: 10, y: self.view.bounds.height - 54, width: self.view.bounds.width - 20, height: 44)
        nextButton.backgroundColor = UIColor.init(red: 42/255, green: 153/255, blue: 214/255, alpha: 1.0)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle(Constants.UIConstants.startButtonTitle, for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextView), for: .touchUpInside)
        self.view.addSubview(nextButton)
    }
    
    // Click on Next Button
    @objc private func nextView() {
//        let nextVC = DetailViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
        guard let path = Bundle.main.path(forResource: "yoga", ofType:"mp4") else {
            debugPrint(ErrorMsg.VideoNF)
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path)) // Open AVVideo Player For yoga mp4
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }

    }

    // Load Static HTML
    private func loadHTML() {
        do {
            guard let filePath = Bundle.main.path(forResource: "intro", ofType: "html")
                else {
                    // File Error
                    debugPrint(ErrorMsg.FileNF)
                    return
            }
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            DispatchQueue.main.async {
                self.webView.loadHTMLString(contents as String, baseURL: baseUrl)
            }
        }
        catch {
            debugPrint(ErrorMsg.FileNF)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ArhamYogaViewController : UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

