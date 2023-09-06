import SwiftUI
import CoreLocation

struct MainView: View {
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
                ContentView(model: model)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(BlurWindow())
                if model.showRightPane {
                    HStack(spacing: 0) {
                        Divider()
                        RightPaneDailyForecastView(model: model)
                            .frame(width: 400)
                            .background(BlurWindow())
                    }
                    .transition(.move(edge: model.showRightPane ? .trailing : .leading))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: model.showRightPane)
        }
        .searchable(text: $searchModel.queryFragment, prompt: Text("Search for location")) {
            if !searchModel.isSearchEmpty {
                LocationSearchResultView(model: searchModel)
            }
        }
        .task {
            model.getFavoriteLocations()
            await model.getForecastForSelectedLocation()
        }
        .toolbar {
            ToolbarItem {
                Button(action: { withAnimation { model.saveLocation() } }) {
                    Label("Add location", systemImage: "plus")
                }
                .help("Add to favorite places")
                .keyboardShortcut("n", modifiers: .command)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { withAnimation { model.removeLocation() } }) {
                    Label("Delete location", systemImage: "trash.fill")
                }
                .help("Remove place")
                .keyboardShortcut("d", modifiers: .command)
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { withAnimation { model.showRightPane.toggle() } }) {
                    Label("Show/Hide right pane", systemImage: "sidebar.right")
                }
                .help("Show/hide right pane")
                .keyboardShortcut("s", modifiers: .command)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: .init(), searchModel: .init())
            .frame(width: 1200, height: 1000)
    }
}
