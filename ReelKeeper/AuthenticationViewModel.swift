import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import FirebaseAuthUI

class AuthenticationViewModel: ObservableObject {

  enum SignInState {
    case signedIn
    case signedOut
  }
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    fileprivate var currentNonce: String?

  @Published var state: SignInState = .signedOut
    init(){
        if Auth.auth().currentUser != nil {
            state = .signedIn
            print("yes")
        } else {
            print("not logged in")
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
          fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
          )
        }

        let charset: [Character] =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
          charset[Int(byte) % charset.count]
        }

        return String(nonce)
      }
    private func authenticateUserWithGoogle(for user: GIDGoogleUser?, with error: Error?, _ link: Bool = false) {
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
        if(link == true){
            linkAccount(credential)
        } else {
            signInWithCredential(credential)
        }
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }

    func handleSignInWithGoogle(link: Bool = false) {
      if (GIDSignIn.sharedInstance.hasPreviousSignIn() && link == false) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
            authenticateUserWithGoogle(for: user, with: error)
        }
      } else {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
            authenticateUserWithGoogle(for: user, with: error)
        }
      }
    }
    func signInWithCredential(_ credential: AuthCredential) {
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
    func signOut() {
      GIDSignIn.sharedInstance.signOut()
      
      do {
        try Auth.auth().signOut()
        
        state = .signedOut
      } catch {
        print(error.localizedDescription)
      }
    }

    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, link: Bool = false) {
        if case .failure(let failure) = result {
            let errorMessage = failure.localizedDescription
            print(errorMessage)
        } else if case .success(let success) = result {
            if let appleIdCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    print ("where nonce")
                    return
                }
                guard let appleIdToken = appleIdCredential.identityToken else {
                    print("unable to fetch id token")
                    return
                }
                
                guard let idTokenString = String(data: appleIdToken, encoding: .utf8) else {
                    print("failed to serialize token")
                    return
                }
                
                let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                               rawNonce: nonce,
                                                               fullName: appleIdCredential.fullName)
                if(link == true){
                    linkAccount(credential)
                } else {
                    signInWithCredential(credential)
                }
            }
        }
    }
    
    func linkAccount(_ credential: AuthCredential){
        let user = Auth.auth().currentUser
        user?.link(with: credential)
    }
    
    func unlinkAccount(_ providerId: String) {
        Auth.auth().currentUser?.unlink(fromProvider: providerId) { user, error in
            print("Success")
        }
    }
}
