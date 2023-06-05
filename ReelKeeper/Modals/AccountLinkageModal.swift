import SwiftUI
import FirebaseFirestore
import AuthenticationServices
import FirebaseAuthUI


struct AccuntLinkageModal: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: AuthenticationViewModel
    let providers = Auth.auth().currentUser!.providerData

    @State private var googleLinkage = false
    @State private var appleLinkage = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    init(){
        for provider in providers {
            if(provider.providerID == "google.com"){
                _googleLinkage = State(initialValue: true)
            } else if(provider.providerID == "apple.com") {
                _appleLinkage = State(initialValue: true)
            }
        }
    }
    func showAlertMessage(message: String) {
        alertMessage = message
        showAlert.toggle()
    }
    var body: some View {
        VStack {
            Text("Manage \nAccount Linkage")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.top, 350)
                Spacer()
                if(googleLinkage == true) {
                    CustomButton(
                        text:.constant("Unlink Google Account"),
                        disableOn: .constant(!appleLinkage),
                        customAction: .constant {
                            viewModel.unlinkAccount("google.com")
                            googleLinkage.toggle()
                            showAlertMessage(message: "Google Account has been Unlinked")
                        },
                        image: .constant(nil)
                    )
                }
                else {
                    CustomButton(
                        text:.constant("Sign in with Google"),
                        disableOn: .constant(false),
                        customAction: .constant {
                            viewModel.handleSignInWithGoogle(link: true)
                        },
                        image: .constant("google-image")
                    )
                }
                if(appleLinkage == true){
                    Button(action: {
                        viewModel.unlinkAccount("apple.com")
                        appleLinkage.toggle()
                        showAlertMessage(message: "Apple Account has been Unlinked")
                    }, label: {
                      HStack {
                        Text("Unlink Apple Account")
                              .foregroundColor(colorScheme == .dark ? .black : .white)
                              .font(.headline)
                      }
                      .frame(width: 240, height: 50)
                      .background(colorScheme == .dark ? .white : .black)
                      .cornerRadius(8)
                    })
                    .padding()
                    .shadow(radius: 2)
                    .disabled(!googleLinkage)
                } else {
                    SignInWithAppleButton { request in
                        viewModel.handleSignInWithAppleRequest(request)
                    } onCompletion: { result in
                        viewModel.handleSignInWithAppleCompletion(result, link: true)
                    }
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(width: 240, height: 50)
                    .padding(.bottom)
                    .shadow(radius: 2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
    }
}
struct AccountLinkageModal_Previews: PreviewProvider {
    static var previews: some View {
        AccuntLinkageModal()
    }
}
