//
//  ViewController.swift
//  ExParsing
//
//  Created by 김종권 on 2022/08/27.
//

import UIKit

struct MyModel: Codable {
  let type: String
  let id: String
}

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let someString = "123456"
    print(someString.map { String($0) + "a" }) // ["1a", "2a", "3a", "4a", "5a", "6a"]
    print(someString.flatMap { String($0) + "a" }) // ["1", "a", "2", "a", "3", "a", "4", "a", "5", "a", "6", "a"]
    
    let arr = [[1,2,3], [3,4,5]]
    print(arr.map { $0 + [0] }) // [[1, 2, 3, 0], [3, 4, 5, 0]]
    print(arr.flatMap { $0 + [0] }) // [1, 2, 3, 0, 3, 4, 5, 0]
    
    let jsonString: String? = """
    {
    "type":"someType",
    "id":"someID"
    }
    """
    
    let someString2 = "123"
    print(someString2.map { String($0) + "0" }) // ["10", "20", "30"]
    
    let someString3: String? = "123"
    print(someString3.map(Int.init)) // Optional(Optional(123))
    
    // String -> Model
    /// jsonString > Data(utf8) > model
    let modelNormal = try? JSONDecoder().decode(MyModel.self, from: Data(jsonString!.utf8))
    print(modelNormal)
    
    let model = jsonString
      .map(\.utf8)
      .map(Data.init(_:))
      .flatMap { try? JSONDecoder().decode(MyModel.self, from: $0) }
    
    // String -> [String: Any]
    /// jsonString > Data(utf8) > [String: Any]
    let dictNormal = try? JSONSerialization.jsonObject(with: Data(jsonString!.utf8), options: []) as? [String:Any]
    print(dictNormal)
    
    let dict = jsonString
      .map(\.utf8)
      .map(Data.init(_:))
      .flatMap { try? JSONSerialization.jsonObject(with: $0) as? [String: Any] }
    
    print(model)
    print(dict)
  }
}

extension Sequence {
  @inlinable public func myMap<T>(_ transform: (Element) -> T) -> [T] {
    var result = [T]()
    for e in self {
      result.append(transform(e))
    }
    return result
  }
  
  @inlinable public func myFlatMap<T: Sequence>(
    _ transform: (Element) throws -> T
  ) rethrows -> [T.Element] {
    var result = [T.Element]()
    for e in self {
      result.append(contentsOf: try transform(e))
    }
    return result
  }
}
