//
//  NetworkManager.swift
//  GetImages
//
//  Created by zun on 23/04/2019.
//  Copyright © 2019 zun. All rights reserved.
//

import Foundation

final class NetWorkManager {
  static let shared = NetWorkManager()
  
  private init() { }
  
  func request(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
      completion(data, error) 
    }
    task.resume()
  }
}
