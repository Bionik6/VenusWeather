import SwiftUI

struct RightPaneDailyForecastView: View {
    @ObservedObject private var model: VenusModel

    init(model: VenusModel) {
        self.model = model
    }

    var body: some View {
        VStack {
            if let forecast = model.dailyForecast {
                VStack(alignment: .leading, spacing: 4) {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
            }
            ScrollView {
                Grid(alignment: .leading, verticalSpacing: 16.0) {
                    ForEach(model.dateHourlyForecasts) { forecast in
                        HourlyForecastRow(hourlyForecast: forecast)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)

        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        RightPaneDailyForecastView(model: .init())
    }
}
