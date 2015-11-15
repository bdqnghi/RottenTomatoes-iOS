//
//  Movie.swift
//  RottenTomatoes
//
//  Created by Nghi Bui on 11/14/15.
//  Copyright © 2015 nghibui. All rights reserved.
//

import Foundation

class Movie: NSObject {
    
    var dict: NSDictionary
    
    init(dictionary: NSDictionary) {
        dict = dictionary
    }
    
    var title: NSString {
        get {
            return dict["title"] as! NSString
        }
    }
    
    var year: NSNumber {
        get {
            return dict["year"] as! NSNumber
        }
    }
    
    var posters: NSDictionary {
        get {
            return dict["posters"] as! NSDictionary
        }
    }
    
    var thumbnailURL: NSURL {
        get {
            return NSURL(string: (self.posters["detailed"] as! NSString).stringByReplacingOccurrencesOfString("tmb", withString: "det"))!
        }
    }
    
    var posterURL: NSURL {
        get {
            return NSURL(string: (self.posters["original"] as! NSString).stringByReplacingOccurrencesOfString("tmb", withString: "ori"))!
        }
    }
    
    var ratings: NSDictionary {
        get {
            return dict["ratings"] as! NSDictionary
        }
    }
    
    var criticsScore: NSNumber {
        get {
            return self.ratings["critics_score"] as! NSNumber
        }
    }
    
    var audienceScore: NSNumber {
        get {
            return self.ratings["audience_score"] as! NSNumber
        }
    }
    
    var mpaaRating: NSString {
        get {
            return dict["mpaa_rating"] as! NSString
        }
    }
    
    var synopsis: NSString {
        get {
            return dict["synopsis"] as! NSString
        }
    }
    
}