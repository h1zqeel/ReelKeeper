import SwiftUI

struct CustomButton: View {
    @Environment(\.colorScheme) var colorScheme

    @Binding var text: String
    @Binding var disableOn: Bool
    @Binding var customAction: () -> Void
    @Binding var image: String?
    var body: some View {
        Button(action: customAction, label: {
          HStack {
              if(image != nil){
                  Image(image!)
                      .resizable()
                      .frame(width: 20, height: 20)
              }
            Text(text)
                  .foregroundColor(colorScheme == .dark ? .black : .white)
                  .font(.headline)
          }
          .frame(width: 240, height: 50)
          .background(colorScheme == .dark ? .white : .black)
          .cornerRadius(8)
        })
        .padding()
        .shadow(radius: 2)
        .disabled(disableOn)
    }
}

