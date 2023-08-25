//
//  DailyForecastView.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 21/08/2023.
//

import SwiftUI

struct DailyForecastView: View {

    let dailyForecast: DailyForecast

    init(dailyForecast: DailyForecast) {
        self.dailyForecast = dailyForecast
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(dailyForecast.date.formatted(date: .abbreviated, time: .omitted))
                .font(.h6)
            HStack(spacing: 20) {
                Image(systemName: dailyForecast.imageName)
                    .font(.weatherIconBig)
                    .symbolRenderingMode(.multicolor)
                VStack(spacing: 20) {
                    Text(dailyForecast.highTempterature).font(.h6Medium)
                    Text(dailyForecast.lowTemperature).font(.h6)
                }
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 40)
        .blurBackground()
    }
}

struct DailyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        DailyForecastView(dailyForecast: .dummy)
    }
}
