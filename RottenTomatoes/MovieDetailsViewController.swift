//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Nghi Bui on 11/13/15.
//  Copyright © 2015 nghibui. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var detailSynopsisLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
   
    @IBOutlet weak var scrollView: UIScrollView!
    var movie = Movie!()
    
    @IBOutlet weak var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTitleLabel.text = movie.title as String
            
        detailSynopsisLabel.text = movie.synopsis as String
        
        let url = movie.thumbnailURL
        
        detailImageView.setImageWithURL(url)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        // Resize the UIView to fit the contents
        var frame = contentView.frame
        let height = max(frame.size.height, detailSynopsisLabel.frame.origin.y + detailSynopsisLabel.bounds.height + 20) + tabBarController!.tabBar.frame.height;
        frame.size.height = height + screenSize.height
        contentView.frame = frame
        
        // Set the content size of the UIScrolLView
        scrollView.contentSize = CGSizeMake(screenSize.width, frame.origin.y + height)
        addGesture()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Gesture
    
    func addGesture() {
        let tapScrollView = UITapGestureRecognizer(target: self, action: "expandDetail:")
        self.scrollView.addGestureRecognizer(tapScrollView)
        
        detailImageView.userInteractionEnabled = true
        let tapPoster = UITapGestureRecognizer(target: self, action: "collapseDetail:")
        self.detailImageView.addGestureRecognizer(tapPoster)
        
    }
    
    func expandDetail(sender:UITapGestureRecognizer) {
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.scrollView.frame = CGRectMake(0 , 178, self.view.frame.width, 390)
            }, completion: nil)
    }
    
    func collapseDetail(sender:UITapGestureRecognizer) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.scrollView.frame = CGRectMake(0 , 378, self.view.frame.width, 190)
            }, completion: nil)
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
