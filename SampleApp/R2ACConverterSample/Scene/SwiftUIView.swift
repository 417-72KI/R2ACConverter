import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(R.image.foo_bar_1)
                    Image(.fooBar1)
                }.background(Color(uiColor: R.color.blue()!))
                HStack {
                    Image(uiImage: R.image.foo_bar_1_2()!)
                    Image(.fooBar12)
                }.background(Color(R.color.blue_1_2))
                HStack {
                    Image(uiImage: UIImage(resource: R.image.foo_bar_2)!)
                    Image(.fooBar2)
                }.background { Color(uiColor: R.color.blue()!) }
                HStack {
                    Image(uiImage: .init(resource: R.image.foo_bar_baz)!)
                    Image(.fooBarBaz)
                }.background {
                    Color(R.color.blue1_2)
                }
            }.padding(8)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    SwiftUIView()
}
