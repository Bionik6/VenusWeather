import MapKit
import SwiftUI

@MainActor
class LocationSearchModel: NSObject, ObservableObject {
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }

    @Published var results: [MKLocalSearchCompletion] = []
    @Published var selectedLocation: MKLocalSearchCompletion?
    var onConfirmLocationSelection: ((VenusLocation) -> Void)?

    public override init() {
        super.init()
        searchCompleter.queryFragment = queryFragment
        searchCompleter.delegate = self
    }

    public func selectLocation(_ location: MKLocalSearchCompletion) {
        self.selectedLocation = location
        Task { try await locationSearch(forLocalSearchCompletion: location) }
    }

    private func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion) async throws {
        do {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = localSearch.title
            let search = MKLocalSearch(request: searchRequest)
            let response = try await search.start()
            guard let item = response.mapItems.first else { return }
            let coordinate = item.placemark.coordinate

            let location = VenusLocation(
                latitude: coordinate.latitude,
                longitute: coordinate.longitude,
                city: item.placemark.name,
                country: item.placemark.country
            )
            emptyResults()
            onConfirmLocationSelection?(location)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }

    var isSearchEmpty: Bool {
        queryFragment.isEmpty && results.isEmpty
    }

    private func emptyResults() {
        self.results = []
        self.queryFragment = ""
        self.selectedLocation = nil
    }
}

extension LocationSearchModel: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
