import Firebase
import GoogleSignIn
import FirebaseFirestore


class FireStoreHelper: ObservableObject {
    
    let currentUser = Auth.auth().currentUser
    let db = Firestore.firestore()
//    , dismiss: @escaping () -> Void callback 
    func addDataInCollection(name: String, data: Dictionary<String, Any>) {
        if(currentUser?.email == nil){
            print("Auth Error Occured")
            return
        }
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(currentUser?.email ?? "nil").collection("movies").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    func updateDataInCollection(id: String, name: String, data: Dictionary<String, Any>) {
        if(currentUser?.email == nil){
            print("Auth Error Occured")
            return
        }
        db.collection("users").document(currentUser?.email! ?? "nil").collection(name).document(id).updateData(data) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
