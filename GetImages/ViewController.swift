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
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NetWorkManager.shared.request(url: url!) { data, error in
      if let error = error {
        print(error)
      }
      if let data = data {
        do {
          let imageURL = try HTML(html: data, encoding: .utf8)
          for item in imageURL.xpath("//img[@class='jq-lazy'") {
            print(item)
          }
        } catch {
          print("error")
        }
      }
    }
  }

}

