//
//  AnimationController.swift
//  CVTest
//
//  Created by Joseph Skimmons on 8/27/17.
//  Copyright © 2017 Joseph Skimmons. All rights reserved.
//

import UIKit

class AnimationController: UIViewController {

    @IBOutlet weak var ball: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 2.0, delay: 0.4,
                       options: [.repeat, .autoreverse, .curveEaseInOut],
                       animations: {
                        self.ball.center.x += self.view.bounds.width - 100
        },
                       completion: nil
        )
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
