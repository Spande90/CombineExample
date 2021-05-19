//
//  ApiCaller.swift
//  CombineExample
//
//  Created by Siddharth on 19/05/21.
//

import Combine
import Foundation

class APICaller{
    static let shared = APICaller()
    
    func fetchCompanies() -> Future<[String],Error>{
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                promise(.success(["Apple","Google","Oracle","Sun"]))
            }
        }
        
    }
}
