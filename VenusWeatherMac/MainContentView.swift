//
//  MainContentView.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 19/08/2023.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct MainContentView: View {
    @ObservedObject private var model: VenusModel

    init(model: VenusModel) {
        self.model = model
    }

    @State private var selection: Int = 1
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BETWEEN_SECTION_SPACING) {
                HEADER
                HStack {
                    MAIN_CARD
                    VStack {
                    }
                }

                VStack(alignment: .leading, spacing: TITLE_PADDING) {
                    Text("10 days forecast".uppercased())
                        .font(.mainBold)

                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(model.dailyForecasts) {
                                DailyForecastView(dailyForecast: $0)
                            }
                        }
                    }
                    .frame(maxHeight: 200).fixedSize(horizontal: false, vertical: true)
                    .scrollIndicators(.hidden)

                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            HStack {
                                Picker("", selection: self.$selection) {
                                    Text("Summary").tag(1)
                                    Text("Daily").tag(2)
                                }
                                .font(.subTextBold)
                                .pickerStyle(.segmented)
                                .frame(maxWidth: 250)
                                .padding(.vertical, 12)
                                .padding(.leading, 12)
                                Spacer()
                            }
                            Divider()
                        }
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 0) {
                                ForEach(model.hourlyForecasts) {
                                    HourlyForecastView(hourlyForecast: $0)
                                }
                            }
                        }
                        .frame(maxHeight: 324).fixedSize(horizontal: false, vertical: true)
                        .scrollIndicators(.hidden)
                    }
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.primary.opacity(0.05), .primary.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }

            }
            .foregroundColor(.primary)
            .frame(maxWidth: 1200)
            .padding(16)
            .task {
                await model.weather(for: CLLocation(latitude: 14.77943584488948, longitude: -17.370824952178218))
            }
        }

    }

    @ViewBuilder
    private func makeDetails(title: String, iconName: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName).font(.subText)
                Text(title).font(.subText)
            }
            Text(value).font(.main)
        }
    }

    private var HEADER: some View {
        HStack { // Header
            Text("London, England")
                .foregroundStyle(.primary)
                .font(.largeTitle)
            Button(action: { }) {
                Image(systemName: "house.circle")
                    .font(.largeTitle)
            }.buttonStyle(.plain)
        }
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var MAIN_CARD: some View {
        VStack(alignment: .leading, spacing: 28) { //
            Text("Current Weather")
                .font(.title)
                .fontWeight(.medium)

            HStack(spacing: 24) {
                Image(systemName: model.currentWeather?.symbolName ?? "cloud.sun.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 80))
                    .foregroundStyle(.primary)
                Group {
                    if let temperature = model.currentWeather?.temperature {
                        Text(format(temperature: temperature))
                    } else {
                        Text("---")
                    }
                }
                .font(.system(size: 70))

                VStack(alignment: .leading) {
                    Text("Mostly cloudy")
                        .fontWeight(.medium)
                    Text("Feels like   18º")
                }
            }

            Text("The skies will be partly cloudy. The low will be 15º")
                .font(.main)

            HStack(spacing: 24) {
                makeDetails(title: "Wind", iconName: "wind", value: "16 km/h")
                makeDetails(title: "Humidity", iconName: "drop", value: "87%")
                makeDetails(title: "Visibility", iconName: "eye", value: "10km")
                makeDetails(title: "Presssure", iconName: "speedometer", value: "1019mb")
                makeDetails(title: "UV Index", iconName: "sun.max.fill", value: "0")
            }
        }
        .padding(24)
        .blurBackground()
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView(model: .init())
    }
}


extension View {
    func blurBackground() -> some View {
        self
            .background(.ultraThinMaterial)
            .cornerRadius(12)
    }
}
