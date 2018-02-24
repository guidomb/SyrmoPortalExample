//
//  TrickName.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import Portal

internal let trickNameViewHeight: UInt = 30

public func trickNameView(name: String, textSize: UInt = 21, height: UInt = 35) -> Component<Syrmo.Action> {
    let topMargin: UInt = 5
    return label(
        text: name,
        style: labelStyleSheet() { base, label in
            base.backgroundColor = .white
            label.textColor = ColorPalette.Secondary.color05
            label.textSize = textSize
            label.textFont = Montserrat.bold
        },
        layout: layout() {
            $0.height = Portal.Dimension(value: height - topMargin)
            $0.margin = .by(edge: edge() {
                $0.horizontal = 10
                $0.top = topMargin
            })
        }
    )
}
