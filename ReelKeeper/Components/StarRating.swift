import SwiftUI

struct StarRating: View {
    @Binding var rating: Int
    @Binding var label: String?
    var maxiumumRating = 5
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.blue
    
    var body: some View {
        HStack  {
            if label?.isEmpty == false {
                Text(label ?? "")
                Spacer()
            }
            ForEach(1..<maxiumumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if(number > rating) {
            return offImage ?? onImage
        }
        else {
            return onImage
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(rating: .constant(4), label: .constant(""))
    }
}
