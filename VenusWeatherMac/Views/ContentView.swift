import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject private var model: VenusModel
    @ObservedObject private var searchModel: LocationSearchModel

    init(model: VenusModel, searchModel: LocationSearchModel) {
        self.model = model
        self.searchModel = searchModel
        searchModel.onConfirmLocationSelection = { location in
            Task { await model.select(location: location) }
        }
    }

    var body: some View {
        NavigationSplitView {
            SidebarView(model: model)
                .padding(.vertical, 12)
                .navigationSplitViewColumnWidth(min: 240, ideal: 260, max: 320)
        } detail: {
            HStack(spacing: 0) {
                MainContentView(model: model)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlurWindow())
                if model.showRightPane {
                    HStack(spacing: 0) {
                        Divider()
                        DetailView(model: model)
                            .frame(width: 400)
                            .background(BlurWindow())
                    }
                    .transition(.move(edge: model.showRightPane ? .trailing : .leading))
                }
            }.animation(.easeInOut(duration: 0.3), value: model.showRightPane)
        }
        .searchable(text: $searchModel.queryFragment, prompt: Text("Search for location"))
        .searchSuggestions({
            if !searchModel.isSearchEmpty {
                LocationSearchResultView(model: searchModel)
            }
        })
        .task {
            model.getFavoriteLocations()
            await model.getForecastForSelectedLocation()
        }
        .toolbar {
            ToolbarItem {
                Button(action: {}) {
                    Label("Add Item", systemImage: "plus")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { withAnimation { model.showRightPane.toggle() } }) {
                    Label("Add Item", systemImage: "sidebar.right")
                }
            }
        }
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: .init(), searchModel: .init())
            .frame(width: 1200, height: 1000)
    }
}
