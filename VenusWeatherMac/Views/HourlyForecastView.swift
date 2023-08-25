//
//  HourlyForecastView.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 21/08/2023.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {

    private let hourlyForecast: HourlyForecast

    init(hourlyForecast: HourlyForecast) {
        self.hourlyForecast = hourlyForecast
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    Spacer()
                    Image(systemName: hourlyForecast.imageName)
                        .symbolRenderingMode(.multicolor)
                        .font(.weatherIconMedium)
                    Text(hourlyForecast.temperature).font(.h5Medium)
                    Text(hourlyForecast.condition).font(.subText)
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Label("0%", systemImage: "drop.fill").font(.subText)
                        Label("9km/h", systemImage: "drop.fill").font(.subText)
                    }
                    Spacer()
                }
                .frame(width: 160, alignment: .leading)
                .padding(.leading, 20)
                Rectangle()
                    .frame(width: 4)
                    .foregroundColor(Color.primary.opacity(0.2))
            }

            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 2)
                .foregroundColor(.primary.opacity(0.4))
            Text(hourlyForecast.date.formatted(date: .omitted, time: .shortened))
                .font(.main)
                .frame(height: 48)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial, in: Rectangle())
        }

    }
}

struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(hourlyForecast: .dummy)
    }
}
