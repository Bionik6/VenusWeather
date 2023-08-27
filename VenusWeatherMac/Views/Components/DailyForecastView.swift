import SwiftUI

struct DailyForecastView: View {

    let dailyForecast: DailyForecast

    init(dailyForecast: DailyForecast) {
        self.dailyForecast = dailyForecast
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(format(date: dailyForecast.date))
                .font(.h6)
            HStack(spacing: 20) {
                Image(systemName: dailyForecast.imageName)
                    .font(.weatherIconBig)
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                VStack(spacing: 20) {
                    Text(dailyForecast.highTempterature)
                        .font(.h6Medium)
                        .help("High temperature")
                    Text(dailyForecast.lowTemperature)
                        .font(.h6)
                        .help("Low temperature")
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
