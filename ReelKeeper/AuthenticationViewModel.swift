import Firebase
import GoogleSignIn

class AuthenticationViewModel: ObservableObject {

  // 1
  enum SignInState {
    case signedIn
    case signedOut
  }
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
  // 2
  @Published var state: SignInState = .signedOut
//    if (Auth.auth().currentUser?.uid != nil) {
//        self.state = .signedIn
//    }
    init(){
        if Auth.auth().currentUser != nil {
            state = .signedIn
            print(Auth.auth().currentUser?.email)
            print("yes")
        } else {
            print("not logged in")
          // No user is signed in.
         // ...
        }
    }
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          self.userDefault.set(true, forKey: "usersignedin")
          self.userDefault.synchronize()
          self.state = .signedIn
        }
      }
    }

    func signIn() {
        print("sign in")
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUser(for: user, with: error)
        }
      } else {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
        }
      }
    }
    
    func signOut() {
      GIDSignIn.sharedInstance.signOut()
      
      do {
        try Auth.auth().signOut()
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }


}
