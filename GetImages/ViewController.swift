//
//  ViewController.swift
//  GetImages
//
//  Created by zun on 23/04/2019.
//  Copyright © 2019 zun. All rights reserved.
//

import UIKit
import Kanna

class ViewController: UIViewController {
  
  let url = URL(string: "https://www.gettyimagesgallery.com/collection/sasha/")
  let cellIdentifier = "CollectionViewCell"
  var imageURL: [String] = []
  let cache = NSCache<AnyObject, UIImage>()
  var size = UIScreen.main.bounds.width / 3 - 10
  
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  @IBAction func buttonDidTap(_ sender: Any) {
    let alertController = UIAlertController(title: "", message: "정렬방식을 선택해주세요.", preferredStyle: .actionSheet)
    
    let grid = UIAlertAction(title: "GRID", style: .default) { _ in
      self.size = UIScreen.main.bounds.width / 3 - 10
      self.collectionView.reloadData()
    }
    
    let list = UIAlertAction(title: "LIST", style: .default) { _ in
      self.size = UIScreen.main.bounds.width
      self.collectionView.reloadData()
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    alertController.addAction(grid)
    alertController.addAction(list)
    alertController.addAction(cancel)
    
    self.present(alertController, animated: true, completion: nil)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUp()
    requestURL()
  }
}

extension ViewController {
  func setUp() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    activityIndicator.startAnimating()
  }
  
  //HTML을 파싱
  func requestURL() {
    guard let url = url else { return }
    
    NetWorkManager.shared.request(url: url) { data, error in
      if let error = error {
        print(error.localizedDescription)
      }
      
      if let data = data {
        do {
          let html = try HTML(html: data, encoding: .utf8)
          
          // Kanna를 이용하여 HTML를 파싱하고 이미지의 주소를 가져옴
          for item in html.xpath("//img[@class='jq-lazy']/@data-src") {
            if let temp = item.text {
              // 이미지 URL을 배열에 저장
              self.imageURL.append(temp)
            }
          }
          DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.collectionView.reloadData()
          }
        } catch {
          print(error.localizedDescription)
        }
      }
    }
  }
  
  // URL 주소에서 이미지 가져오기
  func fetchImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
    //캐시에 저장된 이미지는 바로 불러옴.
    if let cachedImage = cache.object(forKey: url as AnyObject) {
      completion(cachedImage, nil)
      return
    }
    
    NetWorkManager.shared.request(url: url) { [weak self] data, error in
      if let error = error {
        print(error.localizedDescription)
        completion(nil, error)
      }
      
      if let data = data {
        if let image = UIImage(data: data) {
          self?.cache.setObject(image, forKey: url as AnyObject)
          completion(image, nil)
        }
      }
    }
  }
  
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageURL.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell else {
      return UICollectionViewCell()
    }

    if let url = URL(string: imageURL[indexPath.item]) {
      fetchImage(url: url) { image, _ in
        if let image = image {
          DispatchQueue.main.async {
            cell.imageView.image = image
          }
        }
      }
    }
    
    return cell
  }
  
}

extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: size, height: size)
  }
}


