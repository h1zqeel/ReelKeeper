import SwiftUI

struct SaneHeaderText: View {
    @Binding var header: String

    var body: some View {
        Text(header)
            .font(.system(.title3))
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .textCase(nil)
    }
}

struct SaneHeaderText_Previews: PreviewProvider {
    static var previews: some View {
        SaneHeaderText(header: .constant("Header"))
    }
}
