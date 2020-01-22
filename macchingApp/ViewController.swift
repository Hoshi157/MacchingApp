//
//  ViewController.swift
//  macchingApp
//
//  Created by 福山帆士 on 2020/01/22.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        self.imageView.center = self.view.center
        self.imageView.image = UIImage(named: "hoge")
        self.view.addSubview(self.imageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.3, delay:1.0, options:.curveEaseOut, animations: {() in
            self.imageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseOut, animations: {() in
            self.imageView.transform = CGAffineTransform(scaleX: 8.0, y: 8.0)
            self.imageView.alpha = 0
        } , completion: {(Bool) in
            self.imageView.removeFromSuperview()
            let loginView = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginView!,animated:false)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
