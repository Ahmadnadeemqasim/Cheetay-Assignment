//
//  ProgressHud.swift
//  Assignment
//
//  Created by Ahmad Qasim on 1/9/23.
//

import Foundation
import MBProgressHUD

class PaceProgressHUD: MBProgressHUD {
    
    class func addProgressHUDToTop() {
       DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        }
        
    }
    class func hideProgressHUDFromTop() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
        }
    }
    
    class func addProgressHudToView(view:UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
    }
    
    class func hideProgressHudFromView(view:UIView) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
