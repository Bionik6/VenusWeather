import MapKit
import SwiftUI

struct LocationSearchResultView: View {
    @ObservedObject private var model: LocationSearchModel

    init(model: LocationSearchModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(model.results, id: \.self) { result in
                        LOCATION_CELL(result: result)
                            .onTapGesture { model.selectLocation(result) }
                    }
                }
            }
        }
    }

    private func LOCATION_CELL(result: MKLocalSearchCompletion) -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(result.title)
                        .font(.headline)
                    Text(result.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            Divider()
        }
        .padding(.horizontal)
    }
}
