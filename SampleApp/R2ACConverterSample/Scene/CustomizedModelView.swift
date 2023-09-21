import SwiftUI
import RswiftResources

struct Item {
    var image: RswiftResources.ImageResource
}

struct ItemView: View {
    var item: Item

    var body: some View {
        VStack {
            Image(item.image)
        }
    }
}

#if DEBUG
struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemView(item: .init(image: R.image.foo))
        }
    }
}
#endif
