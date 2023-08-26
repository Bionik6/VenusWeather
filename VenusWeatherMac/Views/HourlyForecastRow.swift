//
//  HourlyForecastRow.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 26/08/2023.
//

import SwiftUI

struct HourlyForecastRow: View {
    @State private var showDetails = false
    private let hourlyForecast: HourlyForecast

    init(hourlyForecast: HourlyForecast) {
        self.hourlyForecast = hourlyForecast
    }

    var body: some View {
        GridRow {
            Text(format(hour: hourlyForecast.date))
                .help("Time")
                .font(.main)
            Label(hourlyForecast.temperature, systemImage: hourlyForecast.imageName)
                .font(.main)
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
                .help("Chance of precipitation")
            Label(hourlyForecast.wind, systemImage: "wind")
                .font(.subText)
                .help("Wind speed")
            Button(action: { withAnimation { showDetails.toggle() } }) {
                Image(systemName: "chevron.down.circle.fill")
                    .font(.h6)
                    .rotationEffect(.degrees(showDetails ? 180 : 0))
            }
            .frame(width: 32, height: 32)
            .buttonStyle(.plain)
            .gridCellUnsizedAxes(.horizontal)
        }
        Divider()
        .frame(maxWidth: .infinity)
        if showDetails {
            GridRow {

            }
        }

    }
}

struct HourlyForecastRow_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastRow(hourlyForecast: .dummy)
    }
}
