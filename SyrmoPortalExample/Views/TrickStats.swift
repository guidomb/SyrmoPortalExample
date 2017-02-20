//
//  TrickStats.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import PortalView

internal let statsViewHeight: UInt = 55

public func statsView(stats: SkateTrickStats, screenWidth: UInt, height: UInt? = .none) -> Component<Message> {

    let statsViewProperties = [
        StatsViewProperties(title: "HEIGHT",    value: "\(stats.height)cm"),
        StatsViewProperties(title: "DISTANCE",  value: "\(stats.distance)cm"),
        StatsViewProperties(title: "AIR TIME",  value: "\(stats.airTime)s"),
        StatsViewProperties(title: "POP FORCE", value: "\(stats.popForce)N")
    ]

    let values = statsValuesRow(flexGrow: 2.75, texts: statsViewProperties.map { $0.value }, screenWidth: screenWidth)
    let titles = statsTitlesRow(flexGrow: 0.25, texts: statsViewProperties.map { $0.title }, screenWidth: screenWidth)

    return container(
        children: [
            values,
            titles
        ],
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .column
            }
            if let height = height {
                let bottomMargin: UInt = 10
                $0.height = PortalView.Dimension(value: height - bottomMargin)
                $0.margin = .by(edge: edge() {
                    $0.bottom = bottomMargin
                })
            }
        }
    )
}

fileprivate func statsTitlesRow(flexGrow: Double, texts: [String], screenWidth: UInt) -> Component<Message> {
    return statsRowView(
        flexGrow: flexGrow,
        propertiesBuilder: StatTextViewProperties.titlesRow,
        texts: texts,
        screenWidth: screenWidth
    )
}

fileprivate func statsValuesRow(flexGrow: Double, texts: [String], screenWidth: UInt) -> Component<Message> {
    return statsRowView(
        flexGrow: flexGrow,
        propertiesBuilder: StatTextViewProperties.valuesRow,
        texts: texts,
        screenWidth: screenWidth
    )
}

fileprivate struct StatsViewProperties {

    public var title: String
    public var value: String

}

fileprivate struct StatTextViewProperties {

    public typealias Builder = (String, String, UInt) -> StatTextViewProperties

    static let margin = UInt(2)

    static func titlesRow(textBeforeLayout: String, textAfterLayout: String, width: UInt) -> StatTextViewProperties {
        return StatTextViewProperties(
            textBeforeLayout: textBeforeLayout,
            textAfterLayout: textAfterLayout,
            width: width,
            textSize: 11,
            textColor: ColorPalette.Secondary.color05,
            textFont: Montserrat.regular,
            margin: margin
        )
    }

    static func valuesRow(textBeforeLayout: String, textAfterLayout: String, width: UInt) -> StatTextViewProperties {
        return StatTextViewProperties(
            textBeforeLayout: textBeforeLayout,
            textAfterLayout: textAfterLayout,
            width: width,
            textSize: 20,
            textColor: ColorPalette.Primary.color03,
            textFont: Montserrat.bold,
            margin: margin
        )
    }

    var textBeforeLayout: String
    var textAfterLayout: String
    var width: UInt
    var textSize: UInt
    var textColor: Color
    var textFont: Font
    var margin: UInt

}

fileprivate func statTextView(textViewProperties: StatTextViewProperties) -> Component<Message> {
    return container(
        children: [
            label(
                properties: properties(
                    text: textViewProperties.textBeforeLayout,
                    textAfterLayout: textViewProperties.textAfterLayout
                ),
                style: labelStyleSheet() { base, label in
                    base.backgroundColor = .white
                    label.textSize = textViewProperties.textSize
                    label.adjustToFitWidth = true
                    label.numberOfLines = 1
                    label.minimumScaleFactor = 0.1
                    label.textColor = textViewProperties.textColor
                    label.textFont = textViewProperties.textFont
                },
                layout: layout()
            )
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.flex = flex() {
                $0.grow = .one
            }
            $0.justifyContent = .center
            $0.width = Dimension(value: textViewProperties.width)
            $0.padding = .by(edge: edge() {
                $0.horizontal = textViewProperties.margin
            })
        }
    )

}


fileprivate func statsRowView(
    flexGrow: Double,
    propertiesBuilder: @escaping StatTextViewProperties.Builder,
    texts: [String], screenWidth: UInt) -> Component<Message> {
    
    let sortedTexts = texts.sorted { $0.characters.count > $1.characters.count }
    guard let longestText = sortedTexts.first, let flexGrow = FlexValue(rawValue: flexGrow) else { return container() }

    let marginPerRowEdge = UInt(10)
    let marginPerTextView = UInt(2)
    let textViewWidth = (screenWidth / UInt(texts.count)) - (marginPerRowEdge * marginPerTextView)
    let propertiesForText: (String) -> StatTextViewProperties = { propertiesBuilder(longestText, $0, textViewWidth) }
    let textViews = texts.map{ statTextView(textViewProperties: propertiesForText($0)) }

    return container(
        children: textViews,
        style: styleSheet() {
            $0.backgroundColor = .blue
        },
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .row
                $0.grow = flexGrow
            }
            $0.margin = .by(edge: edge() {
                $0.horizontal = marginPerRowEdge - marginPerTextView
            })
        }
    )
}

