//
//  SettingsView.swift
//  ClaudeUsageBar
//
//  Phase 4 (window surface). A standalone settings panel hosted in its own
//  NSWindow (opened from the dropdown's gear button). Binds directly to the
//  shared AppSettings; sign-out is delegated back to AppDelegate via a closure.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettings
    var onSignOut: () -> Void

    var body: some View {
        Form {
            Section("General") {
                Toggle("Launch at login", isOn: $settings.launchAtLogin)

                Picker("Menu bar display", selection: $settings.menuBarMode) {
                    ForEach(MenuBarMode.allCases) { mode in
                        Text(mode.label).tag(mode)
                    }
                }

                Picker("Refresh every", selection: $settings.refreshIntervalMinutes) {
                    ForEach(AppSettings.refreshChoices, id: \.self) { minutes in
                        Text(minutes == 1 ? "1 minute" : "\(minutes) minutes").tag(minutes)
                    }
                }

                Stepper("Warning threshold: \(settings.warnThreshold)%",
                        value: $settings.warnThreshold, in: 50...95, step: 5)
            }

            Section {
                Button("Sign out", role: .destructive, action: onSignOut)
            } footer: {
                Text("Clears the saved claude.ai session; you'll sign in again.")
            }
        }
        .formStyle(.grouped)
        .frame(width: 360, height: 300)
    }
}
