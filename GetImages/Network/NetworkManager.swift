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
  
  ///URL 주소의 데이터를 가져오는 메소드
  func request(url: URL, completion: @escaping (Data?, Error?) -> Void) {
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) { data, response, error in
      completion(data, error)
      session.finishTasksAndInvalidate()
    }
    task.resume()
  }
}
