import Foundation
import Firebase

class NeriDAO {
    
    private let db = Firestore.firestore()
    
    func save(collection: String, data: [String: Any], completionHandler: @escaping () -> Void) -> DocumentReference? {
        var ref: DocumentReference? = nil
        ref = db.collection(collection).addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
                Crashlytics.sharedInstance().recordError(err)
            } else {
                print("Document added with ID: \(ref!.documentID)")
                completionHandler()
            }
        }
        
        return ref
    }
    
    func update(collection: String, data: [String: Any], id: String, completionHandler: @escaping () -> Void) {
        db.collection(collection).document(id).setData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
                Crashlytics.sharedInstance().recordError(err)
            } else {
                print("Document \(id) updated successfully on database")
                completionHandler()
            }
        }
    }
    
}
