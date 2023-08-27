import SwiftUI

struct Fonts: View {
    var body: some View {
        Text("Hello, World!")
            .font(.h1)
    }
}

struct Fonts_Previews: PreviewProvider {
    static var previews: some View {
        Fonts()
            .frame(width: 500, height: 500)
    }
}


extension Font {
    static let h1 = makeFont(size: 80, weight: .medium)

    static let h2 = makeFont(size: 30, weight: .regular)
    static let h2Bold = makeFont(size: 30, weight: .bold)

    static let h3 = makeFont(size: 28, weight: .regular)
    static let h3Bold = makeFont(size: 28, weight: .bold)

    static let h4 = makeFont(size: 26, weight: .regular)
    static let h4Bold = makeFont(size: 26, weight: .bold)

    static let h5 = makeFont(size: 24, weight: .regular)
    static let h5Medium = makeFont(size: 24, weight: .medium)
    static let h5Bold = makeFont(size: 24, weight: .bold)

    static let h6 = makeFont(size: 22, weight: .regular)
    static let h6Bold = makeFont(size: 22, weight: .bold)
    static let h6Medium = makeFont(size: 22, weight: .medium)

    static let main = makeFont(size: 20, weight: .regular)
    static let mainBold = makeFont(size: 18, weight: .bold)
    static let mainMedium = makeFont(size: 18, weight: .medium)

    static let subText = makeFont(size: 16, weight: .regular)
    static let subTextMedium = makeFont(size: 16, weight: .medium)
    static let subTextBold = makeFont(size: 16, weight: .bold)

    static let mini = makeFont(size: 14, weight: .regular)
    static let miniMedium = makeFont(size: 14, weight: .medium)
    static let miniBold = makeFont(size: 14, weight: .bold)

    static let weatherIconBig = makeFont(size: 40, weight: .bold)
    static let weatherIconMedium = makeFont(size: 32, weight: .medium)


    private static func makeFont(
        size: CGFloat,
        weight: Font.Weight?,
        design: Font.Design? = nil
    ) -> Self {
        Font.system(size: size, weight: weight, design: design)
    }
}
