/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Helpers for loading images and data.
 */


import SwiftUI

let APPListInfo: [AppInfo] = load("landmarkData.json")
var APPListDic = [String : Bool] ()

func loadAPPListDic(_ APPListInfo: [AppInfo] ){
    for item in APPListInfo {
        APPListDic[item.trackName] = false
    }
}
func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: data)
        loadAPPListDic(result as! [AppInfo])
        return result
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


