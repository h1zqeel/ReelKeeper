import SwiftUI

struct SFButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var disableOn: Bool
    @Binding var customAction: () -> Void
    @Binding var SFImage: String
    var body: some View {
        Button(action: customAction) {
            Image(systemName: SFImage)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(colorScheme == .dark ? .white : .black))
                .cornerRadius(12)
                .padding()
                .disabled(disableOn)
        }
    }
}
