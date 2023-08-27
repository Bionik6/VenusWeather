import SwiftUI
import CoreLocation

struct ContentView: View {
    @State private var attributionLink: URL?
    @State private var attributionLogo: URL?
    @ObservedObject private var model: VenusModel
    @ObservedObject private var searchModel: LocationSearchModel
    @Environment(\.colorScheme) private var colorScheme
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn

    init(model: VenusModel, searchModel: LocationSearchModel) {
        self.model = model
        self.searchModel = searchModel
        searchModel.onConfirmLocationSelection = { location in
            Task { await model.select(location: location) }
        }
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            VStack {
                Text("Sidebar")
                Spacer()
                if let attributionLogo, let attributionLink {
                    VStack {
                        AsyncImage(url: attributionLogo) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                        } placeholder: {
                            EmptyView()
                        }
                        Link("Other data sources", destination: attributionLink)
                            .font(.miniMedium)
                    }
                }
            }
            .padding(.vertical, 12)
            .navigationSplitViewColumnWidth(min: 240, ideal: 260, max: 320)
        } content: {
            MainContentView(model: model)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(Color.clear)
                .background(BlurWindow())
        } detail: {
            DetailView(model: model)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BlurWindow())
                .navigationSplitViewColumnWidth(min: 400, ideal: 400, max: 400)
        }
        .searchable(text: $searchModel.queryFragment, prompt: Text("Search for location"))
        .searchSuggestions({
            if !searchModel.isSearchEmpty {
                LocationSearchResultView(model: searchModel)
            }
        })
        .task {
            await model.getForecastForSelectedLocation()
        }
        .task {
            let attribution = try? await model.service.attribution
            attributionLink = attribution?.legalPageURL
            attributionLogo = colorScheme == .light
            ? attribution?.combinedMarkDarkURL
            : attribution?.combinedMarkLightURL
        }
        /* .toolbar {
         ToolbarItem {
         Button(action: addItem) {
         Label("Add Item", systemImage: "plus")
         }
         }
         }*/
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init(), searchModel: .init())
    }
}
