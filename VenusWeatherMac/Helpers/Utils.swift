//
//  Utils.swift
//  VenusWeatherMac
//
//  Created by Ibrahima Ciss on 25/08/2023.
//

import Foundation

let TITLE_PADDING: CGFloat = 16
let BETWEEN_SECTION_SPACING: CGFloat = 28
let BOX_PADDING: CGFloat = 16

func format(temperature: Measurement<UnitTemperature>) -> String {
    let intValue = Int(temperature.value)
    switch temperature.unit {
    case .celsius:
        return "\(intValue)º"
    case .fahrenheit:
        return "\(intValue)F"
    case .kelvin:
        return "\(intValue)K"
    default:
        return ""
    }
}
