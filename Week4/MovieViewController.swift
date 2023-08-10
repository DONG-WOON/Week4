//
//  MovieViewController.swift
//  Week4
//
//  Created by 서동운 on 8/7/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import SkeletonView

final class MovieViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var movieList: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isSkeletonable = true
        
        searchBar.delegate = self
        
        indicator.hidesWhenStopped = true
        
        view.showAnimatedSkeleton()
    }
    
    private func callRequest(at date: Int) {
        self.indicator.hidesWhenStopped = false
        self.indicator.startAnimating()
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKEY.boxOfficeKey)&targetDt=\(date)"
        
        AF.request(url).validate().responseDecodable(of: BoxOffice.self) { response in
            switch response.result {
            case .success(let boxOffice):
                self.movieList = boxOffice.boxOfficeResult.dailyBoxOfficeList
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MovieViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        guard let date = Int(text), text.count == 8 else { return }
        
        callRequest(at: date)
    }
    
    func validate() {
        
    }
}

extension MovieViewController: SkeletonTableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell")!
        if !movieList.isEmpty {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = movieList[indexPath.row].movieNm
            configuration.secondaryText = movieList[indexPath.row].openDt
            cell.contentConfiguration = configuration
        }
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "MovieCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, prepareCellForSkeleton cell: UITableViewCell, at indexPath: IndexPath) {
        
        cell.textLabel?.isHidden = indexPath.row == 0
    }
}

