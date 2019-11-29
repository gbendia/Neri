import Foundation
import UIKit

class Caregiver {
    
    static let singleton = Caregiver()
    
    var phoneNumber: String = ""
    var connectedEldersIDs: [String] = [String]() // List of the elders IDs on Firestore
    private static var photos = [String]()
    private static var names = [String]()
    
    private init() {}
    
    private static func getEldersPhotos() -> [UIImage] {
        var images = [UIImage]()
        for photoName in photos {
            images.append(UIImage(named: photoName)!)
        }
        return images
    }
    
    private static func getEldersNames() -> [String] {
        return self.names
    }
    
}
