//
//  VideoViewController.swift
//  Week4
//
//  Created by 서동운 on 8/8/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit

struct Video {
    let author: String
    let date: String
    let play_time: Int
    let thumbnail: String
    let title: String
    let url: String
    
    var contents: String {
        return "\(author) | \(play_time / 60) 분 \(play_time % 60)초"
    }
}

class VideoViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var page = 1 { didSet {print(page) }}
    var isEndPage = false {
        didSet {
            if isEndPage {
                print("끝")
            }
        }
    }
    
    var videoList: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = DefaultCollectionViewLayout()
    }
    
    private func callRequest(searchText: String, page: Int = 1, size: Int = 15) {
        let searchedText = searchText.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!
        let endPoint = "https://dapi.kakao.com/v2/search/vclip"
        let query = "?query=\(searchedText)&size=\(size)&page=\(page)"
        let url = endPoint + query
        let header = HTTPHeader(name: "Authorization", value: "KakaoAK \(APIKEY.kakaoKey)")
        
        DispatchQueue.global().async {
            AF.request(url, headers: [header]).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.isEndPage = json["meta"]["is_end"].boolValue
                    let videoList = json["documents"].arrayValue
                    
                    DispatchQueue.main.async {
                        let videoList = videoList.map({ json in
                            return Video(author: json["author"].stringValue,
                                         date: json["datetime"].stringValue,
                                         play_time: json["play_time"].intValue,
                                         thumbnail: json["thumbnail"].stringValue,
                                         title: json["title"].stringValue,
                                         url: json["url"].stringValue)
                        })
                        self.videoList.append(contentsOf: videoList)
                        self.collectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
        
        cell.update(data: videoList[indexPath.item])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension VideoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        if indexPaths.contains(where: { $0.item == videoList.count - 1 }) && page < 15 && !isEndPage {
            page += 1
            print("🔥 ",#function)
            callRequest(searchText: searchBar.text!, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("✅ ",indexPaths)
    }
}

extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        videoList.removeAll()
        page = 1
        isEndPage = false
        callRequest(searchText: text, page: page)
    }
}

class DefaultCollectionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        let spacing: CGFloat = 3
        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                    heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


