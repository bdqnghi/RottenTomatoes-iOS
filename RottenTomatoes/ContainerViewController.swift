//
//  ContainerViewController.swift
//  RottenTomatoes
//
//  Created by Nghi Bui on 11/15/15.
//  Copyright © 2015 nghibui. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let moviesViewController = segue.destinationViewController as! ViewController
        switch restorationIdentifier! {
        case "topRentals":
            moviesViewController.mode = .TopRentals
        default:
            moviesViewController.mode = .BoxOffice
        }
    }

}
