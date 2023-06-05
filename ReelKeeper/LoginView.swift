import SwiftUI
import AuthenticationServices

struct LoginView: View {

  // 1
  @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.colorScheme) var colorScheme
  var body: some View {

      VStack {
          Text("Welcome \nto ReelKeeper")
              .font(.largeTitle)
              .fontWeight(.bold)
              .foregroundColor(colorScheme == .dark ? .white : .black)
              .padding(.top, 350)
            Spacer()
            CustomButton(
                text: .constant("Sign in with Google"),
                disableOn: .constant(false),
                customAction: .constant {
                    viewModel.handleSignInWithGoogle()
                },
                image: .constant("google-image")
            )
            
            SignInWithAppleButton { request in
                viewModel.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                viewModel.handleSignInWithAppleCompletion(result)
            }
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(width: 240, height: 50)
            .padding(.bottom)
            .shadow(radius: 2)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(colorScheme == .dark ? .black : .white)
  }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
