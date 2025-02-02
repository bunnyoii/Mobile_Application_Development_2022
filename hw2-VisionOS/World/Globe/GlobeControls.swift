/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Controls that people can use to manipulate the globe in a volume.
*/

import SwiftUI

/// Controls that people can use to manipulate the globe in a volume.
struct GlobeControls: View {
    @Environment(ViewModel.self) private var model
    @State private var isTiltPickerVisible: Bool = false

    var body: some View {
        @Bindable var model = model

        VStack(alignment: .tiltButtonGuide) {
            GlobeTiltPicker(isVisible: $isTiltPickerVisible)
                .alignmentGuide(.tiltButtonGuide) { context in
                    context[HorizontalAlignment.center]
                }
                .accessibilitySortPriority(1)

            HStack(spacing: 17) {
                Toggle(isOn: $model.globeEarth.showSun) {
                    Label("Sun", systemImage: "sun.max")
                }

                Toggle(isOn: $model.globeEarth.showPoles) {
                    Label("Poles", systemImage: "mappin.and.ellipse")
                }

                Toggle(isOn: $model.isGlobeRotating) {
                    Label("Rotate", systemImage: "arrow.triangle.2.circlepath")
                }

                Toggle(isOn: $isTiltPickerVisible) {
                    Label("Tilt", systemImage: "cloud.sun.fill")
                }
                .alignmentGuide(.tiltButtonGuide) { context in
                    context[HorizontalAlignment.center]
                }
            }
            .toggleStyle(.button)
            .buttonStyle(.borderless)
            .labelStyle(.iconOnly)
            .padding(12)
            .glassBackgroundEffect(in: .rect(cornerRadius: 50))
            .alignmentGuide(.controlPanelGuide) { context in
                context[HorizontalAlignment.center]
            }
            .accessibilitySortPriority(2)
        }

        // Update the date that controls the Earth's tilt.
        .onChange(of: model.globeTilt) { _, tilt in
            model.globeEarth.date = tilt.date
        }
    }
}

/// A custom picker for choosing a time of year.
private struct GlobeTiltPicker: View {
    @Environment(ViewModel.self) private var model
    @Binding var isVisible: Bool
    @AccessibilityFocusState var axFocusTiltMenu: Bool

    var body: some View {
        Grid(alignment: .leading) {
            Text("Tilt", comment: "The tilt of the Earth's axis.")
                .font(.title)
                .padding(.top, 5)
                .gridCellAnchor(.center)
                .accessibilityFocused($axFocusTiltMenu)
            Divider()
                .gridCellUnsizedAxes(.horizontal)
            ForEach(GlobeTilt.allCases) { tilt in
                GridRow {
                    Button {
                        model.globeTilt = tilt
                        isVisible = false
                    } label: {
                        Text(tilt.name)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityAddTraits(tilt == model.globeTilt ? .isSelected : [])
                    Image(systemName: "checkmark")
                        .opacity(tilt == model.globeTilt ? 1 : 0)
                        .accessibility(hidden: true)
                }
            }
        }
        .padding(12)
        .glassBackgroundEffect(in: .rect(cornerRadius: 20))
        .opacity(isVisible ? 1 : 0)
        .animation(.default.speed(2), value: isVisible)
        .onChange(of: isVisible) { axFocusTiltMenu = true }
    }
}

extension HorizontalAlignment {
    /// A custom alignment to center the tilt menu over its button.
    private struct TiltButtonAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    /// A custom alignment guide to center the tilt menu over its button.
    fileprivate static let tiltButtonGuide = HorizontalAlignment(
        TiltButtonAlignment.self
    )
}

/// A direction to tilt the earth, given as the beginning of a season.
enum GlobeTilt: String, CaseIterable, Identifiable {
    case none, march, june, september, december
    var id: Self { self }

    var date: Date? {
        let month = switch self {
        case .none: 0
        case .march: 3
        case .june: 6
        case .september: 9
        case .december: 12
        }

        if month == 0 {
            return nil
        } else {
            return Calendar.autoupdatingCurrent.date(from: .init(month: month, day: 21))
        }
    }

    var name: String {
        switch self {
        case .none: String(localized: "None", comment: "No tilt to the Earth's axis.")
        case .march: String(localized: "March equinox", comment: "Tilt the Earth to the March equinox.")
        case .june: String(localized: "June solstice", comment: "Tilt the Earth to the June solstice.")
        case .september: String(localized: "September equinox", comment: "Tilt the Earth to the September equinox.")
        case .december: String(localized: "December solstice", comment: "Tilt the Earth to the December solstice.")
        }
    }
}

#Preview {
    GlobeControls()
        .environment(ViewModel())
}
