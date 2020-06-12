//
//  Separator.swift
//  Steps
//
//  Created by Saul Moreno Abril on 09/04/2020.
//  Copyright © 2020 Saul Moreno Abril. All rights reserved.
//

import SwiftUI
import SwifterSwiftUI

/// Item to represent each separator between steps
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct Separator<Element>: View {

    /// Index of this step
    var index: Int

    /// Get step object for the set index
    var step: Step

    /// The main state
    @ObservedObject private(set) var state: StepsState<Element>

    /// The style of the component
    @EnvironmentObject var config: Config

    /// Helper to inspect
    let inspection = Inspection<Self>()

    /// Previous index
    @State private var previousIndex: Int = 0

    /// Current scale to be animated
    @State private var scaleX: CGFloat = 1

    /// Min scale in the axis X
    private let minScaleX: CGFloat = 0.25

    /// Get current step state  for the set index
    private var stepState: StepState {
        return state.stepStateFor(index: index)
    }

    /// Get foreground color for the current step
    private var foregroundColor: Color {
        switch stepState {
        case .uncompleted,
             .current:
            return config.disabledColor
        default:
            return config.primaryColor
        }
    }

    /// Update the scale to animate according the next index
    private func updateScale(nextIndex: Int) {
        let diff = nextIndex - previousIndex
        if abs(diff) != 1 {
            scaleX = 1
            return
        }

        if (previousIndex == index && diff > 0) {
            scaleX = minScaleX
        } else if (nextIndex == index && diff < 0) {
            scaleX = minScaleX
        } else {
            scaleX = 1
        }

    }

    var body: some View {
        Container {
            Rectangle()
                .frame(height: config.lineThickness)
                .scaleEffect(x: scaleX, y: 1, anchor: .center)
        }
        .foregroundColor(foregroundColor)
        .animation(config.animation)
        .onReceive(state.$currentIndex, perform: { (nextIndex) in
            self.updateScale(nextIndex: nextIndex)
            let previousScaleX = self.scaleX
            DispatchQueue.main.asyncAfter(deadline: .now() + self.config.animationDuration) {
                if (self.scaleX != 1 && previousScaleX == self.scaleX) {
                    self.scaleX = 1
                }
            }
            self.previousIndex = nextIndex
        })
            .onReceive(inspection.notice) { self.inspection.visit(self, $0) }
    }
}

#if DEBUG
struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        let state = StepsState(data: ["First", "Second", "Third"])
        return Separator(index: 0, step: Step(title: "First"), state: state).environmentObject(Config())
    }
}
#endif