import SwiftUI

struct SidebarView: View {
    @ObservedObject private var model: VenusModel
    
    init(model: VenusModel) {
        self.model = model
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.favoriteLocations) { favoriteLocation in
                    Button {
                        guard let location = favoriteLocation.location else {
                            return
                        }
                        Task { await model.select(location: location) }
                    } label: {
                        FavoriteLocationView(location: favoriteLocation)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(model: .init())
    }
}

struct FavoriteLocationView: View {
    let location: FavoriteLocation
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(location.location?.city ?? "")
                    .font(.mainMedium)
                Spacer()
                if let currentTemperature = location.currentTemperature {
                    Label(
                        format(temperature: currentTemperature),
                        systemImage: location.imageName
                    )
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                    .font(.h6Medium)
                }
            }
            HStack {
                Text(location.condition)
                    .font(.mini)
                    .foregroundColor(.primary.opacity(0.6))
                Spacer()
                Text(location.lowHighTemperature)
                    .font(.subText)
                    .foregroundColor(.primary.opacity(0.6))
            }
            Divider()
        }
        .padding(.horizontal, 16)
    }
}
