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
    
    func getDocumentByID(collection: String, id: String, completionHandler: @escaping ([String: Any]) -> Void) {
        let docRef = db.collection(collection).document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                completionHandler(data)
            } else {
                print("Document with [ID: \(id)] does not exist on [collection: \(collection)]")
            }
        }
    }
    
    func queryDocumentByField(collection: String, queryField: String, queryValue: Any, completionHandler: @escaping ([[String: Any]]) -> Void) {
        db.collection(collection).whereField(queryField, isEqualTo: queryValue).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var documents = [[String: Any]]()
                for document in querySnapshot!.documents {
                    documents.append(document.data())
                }
                completionHandler(documents)
            }
        }
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