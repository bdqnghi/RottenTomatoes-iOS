//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Nghi Bui on 11/11/15.
//  Copyright © 2015 nghibui. All rights reserved.
//

import UIKit
import AFNetworking
import SVProgressHUD
import SVPullToRefresh

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    var mode: MoviesViewMode = .BoxOffice
    
    var movies: [NSDictionary] = []
    
    var moviesObject: [Movie] = []
    
    var moviesTitle: [String] = []
    
    var filteredMovies : [Movie] = []
    var filteredMoviesTitle: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.hidden = true
        errorLabel.alpha = 0
        segmentControl.selectedSegmentIndex = 0
        tableView.dataSource = self
        tableView.delegate = self
        movieSearchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        SVProgressHUD.show()

        fetchMovies()
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.addPullToRefreshWithActionHandler(fetchMovies)
        tableView.pullToRefreshView.activityIndicatorViewStyle = .White
        
        collectionView.addPullToRefreshWithActionHandler(fetchMovies)
        collectionView.pullToRefreshView.activityIndicatorViewStyle = .White
    }
    
    func fetchMovies(){
      
        let url = NSURL(string: "http://coderschool-movies.herokuapp.com/movies?api_key=xja087zcvxljadsflh214")!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
           
          
            if (self.tableView.pullToRefreshView != nil) {
                self.tableView.pullToRefreshView.stopAnimating()
            }
            
            if (self.collectionView.pullToRefreshView != nil) {
                self.collectionView.pullToRefreshView.stopAnimating()
            }


            guard error == nil else  {
                print("F** this URL, can't use it", error!)
                //self.errorLabel.hidden = false
                
                return
            }
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
            
            //print(json)
            self.movies = json["movies"] as! [NSDictionary]
            for i in 0...self.movies.count-1{
                let newMovie = Movie(dictionary: self.movies[i])
                self.moviesObject.append(newMovie)
                self.moviesTitle.append(newMovie.title as String)
            }
            self.filteredMovies = self.moviesObject
//            for i in 0...self.movies.count-1{
//
//                self.moviesTitle.append(self.movies[i]["title"] as! String)
//            }
            
            dispatch_async(dispatch_get_main_queue(), {()-> Void in
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
                self.collectionView.reloadData()
            })
            
        }
        
        task.resume()

    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMoviesTitle = searchText.isEmpty ? moviesTitle : moviesTitle.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        print(filteredMoviesTitle)
        var newFilteredMovies : [Movie] = []
        if(filteredMoviesTitle.isEmpty == false){
            for i in 0...moviesObject.count-1{
                for j in 0...filteredMoviesTitle.count-1{
                    if(filteredMoviesTitle[j] == moviesObject[i].title){
                        newFilteredMovies.append(moviesObject[i])
                    }
                }
            }
        }
       
        print(newFilteredMovies)
        
        filteredMovies = newFilteredMovies
//        if(filteredMoviesTitle.isEmpty == false){
//            moviesObject.filter({) -> Bool in
//                
//            })
//        }
       
        tableView.reloadData()
    }
    func createMovieObjectFromTitle(title : String) ->Movie{
        var movie: Movie!
        for i in 0...moviesObject.count-1{
            let movieTitle = moviesObject[i].title as String
            if(title == movieTitle){
                movie = moviesObject[i]
            }
        }
        return movie
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return filteredMovies.count;
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        
        //let movieDict = self.movies[indexPath.row]
        let movieObj = self.filteredMovies[indexPath.row]
        //let movieObj = Movie(fromDict: movieDict)
    
//        let url = NSURL(string: movie.valueForKeyPath("posters.thumbnail") as! String)
        
    
        cell.titleLabel.text = movieObj.title as String
        
        cell.synopsisLabel.text = movieObj.synopsis as String
        
//        cell.renderImageView.setImageWithURL(NSURL(string: movieObj.posterUrlString as String)!)
        
        let request = NSURLRequest(URL: movieObj.thumbnailURL)
   
        cell.renderImageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
        cell.renderImageView.alpha = 0.0
        cell.renderImageView.image = image
        UIView.animateWithDuration(1.0, animations: {
                cell.renderImageView.alpha = 1.0
        })
        }, failure: nil)
        
        
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filteredMovies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionMovieCell", forIndexPath: indexPath) as! CollectionMovieCell
         
        let movieObj = self.filteredMovies[indexPath.row]
        
        cell.collectionLabel.text = movieObj.title as String
        
        let request = NSURLRequest(URL: movieObj.thumbnailURL)
        
        cell.collectionImageView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
            cell.collectionImageView.alpha = 0.0
            cell.collectionImageView.image = image
            UIView.animateWithDuration(1.0, animations: {
                cell.collectionImageView.alpha = 1.0
            })
            }, failure: nil)
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }


    @IBAction func onSegmentChangedValue(sender: AnyObject) {
        if(segmentControl.selectedSegmentIndex == 0 ){
            collectionView.hidden = true
            tableView.hidden = false
        }
        else{
            collectionView.hidden = false
            tableView.hidden = true
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var indexPath = AnyObject?()
        if(segmentControl.selectedSegmentIndex == 0){
             indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        }
        else{
            indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
        }
        //let cell = sender as! UITableViewCell
        //let indexPath = tableView.indexPathForCell(cell)
        
        let movie = self.filteredMovies[indexPath!.row]

        
        let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie
    }
}
enum MoviesViewMode {
    case BoxOffice, TopRentals
}

