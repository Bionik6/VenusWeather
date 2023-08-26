//
//  ContentView.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 19/08/2023.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject private var model: VenusModel
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn

    init(model: VenusModel) {
        self.model = model
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $visibility) {
            Text("Sidebar")
                .navigationSplitViewColumnWidth(min: 240, ideal: 260, max: 320)
                .navigationSplitViewStyle(.prominentDetail)
        } content: {
            VStack {
                MainContentView(model: model)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(Color.clear)
            .background(BlurWindow())
        } detail: {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        if let forecast = model.dailyForecast {
                            HStack {
                                Text(format(date: forecast.date))
                                    .font(.h4Bold)
                                Image(systemName: forecast.imageName)
                                    .symbolRenderingMode(.multicolor)
                                    .symbolVariant(.fill)
                                    .font(.h4Bold)
                                Text("\(forecast.highTempterature) | \(forecast.lowTemperature)")
                                    .font(.h3)
                            }
                            Text(forecast.condition)
                                .font(.h5)
                        }
                        Grid(alignment: .leading, verticalSpacing: 16.0) {
                            ForEach(model.dateHourlyForecasts) { forecast in
                                HourlyForecastRow(hourlyForecast: forecast)
                            }
                        }
                        .padding(.top, 12)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)

                }
                .frame(maxWidth: .infinity)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlurWindow())
            .navigationSplitViewColumnWidth(min: 400, ideal: 400, max: 400)
        }
        .searchable(text: $model.searchText, prompt: Text("Search for location"))
        .task {
            await model.getForecastForSelectedLocation()
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
        ContentView(model: .init())
    }
}


struct BlurWindow: NSViewRepresentable {

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .fullScreenUI
        view.blendingMode = .behindWindow
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {

    }
}
