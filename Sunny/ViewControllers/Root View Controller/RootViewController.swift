//
//  RootViewController.swift
//  Sunny
//
//  Created by Molnár Csaba on 2019. 10. 05..
//  Copyright © 2019. Molnár Csaba. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var progressBar: UIProgressView!
    
    let timeduration = 2.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: timeduration) {
            let timer = Timer.scheduledTimer(timeInterval: self.timeduration, target: self, selector: #selector(self.showCitySelector), userInfo: nil, repeats: false)
            
            let percentage = timer.timeInterval / self.timeduration
            
            
            self.progressBar.setProgress(Float(percentage), animated: true)
        }
    }
    
    @objc private func showCitySelector() {
        guard let citySelectorViewController = self.storyboard?.instantiateViewController(withIdentifier: "CitySelectorViewController") as? CitySelectorViewController else { return }
        self.present(citySelectorViewController, animated: true, completion: nil)
    }


}
