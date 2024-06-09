//
//  SelectSwitchesIntent.swift
//  OnlyWidgetExtension
//
//  Created by Jacklandrin on 2024/2/13.
//

import AppIntents
import Switches
import WidgetKit
import Extensions

struct SelectBuildInSwitchesIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Built-In Switches"
    static var description: LocalizedStringResource = "Select the switches you want to display in the widget."
    @Parameter(title: "Built-In Switch")
    var buildInSwitch: BuildInSwitchEntity
    init(buildInSwitch: BuildInSwitchEntity) {
        self.buildInSwitch = buildInSwitch
    }
    init() { }
}
