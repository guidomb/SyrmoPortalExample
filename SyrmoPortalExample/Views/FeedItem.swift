//
//  FeedItem.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import PortalView
import Foundation

fileprivate let skateTrickViewSeparatorHeight: UInt = 10

internal let skateTrickViewHeight =
    headerHeight +
    getReplayImageHeight() +
    trickNameViewHeight +
    statsViewHeight +
    socialActionBarHeight +
    skateTrickViewSeparatorHeight

public func skateTrickView(
    skateTrick: SocialInteractive<SkateTrick>,
    screenWidth: UInt = UInt(getScreenSize().width),
    using bundle: Bundle = .main) -> Component<Message> {
    
    return container(
        children: [
            header(skateTrick: skateTrick.object),
            replayView(replay: skateTrick.object.replay, height: getReplayImageHeight(), using: bundle),
            trickNameView(name: skateTrick.object.name, textSize: 18, height: trickNameViewHeight),
            statsView(stats: skateTrick.object.stats, screenWidth: screenWidth, height: statsViewHeight),
            socialActionBar(forElement: skateTrick, using: bundle).map { .socialAction(action: $0) },
            separator(height: skateTrickViewSeparatorHeight)
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.height = Dimension(value: skateTrickViewHeight)
            $0.flex = flex() {
                $0.direction = .column
            }
            $0.aligment = aligment() {
                $0.items = .stretch
            }
        }
    )
}

fileprivate func separator(height: UInt) -> Component<Message> {
    let margin: UInt = 1
    return container(
        children: [
            container(
                children: [],
                style: styleSheet() {
                    $0.backgroundColor = ColorPalette.Primary.color06
                },
                layout: layout() {
                    $0.height = Dimension(value: skateTrickViewSeparatorHeight - 2 * margin)
                    $0.flex = flex() {
                        $0.grow = .one
                    }
                    $0.margin = .by(edge: edge() {
                        $0.vertical = margin
                    })
                }
            )
        ],
        style: styleSheet() {
            $0.backgroundColor = ColorPalette.Primary.color04
        },
        layout: layout() {
            $0.height = Dimension(value: skateTrickViewSeparatorHeight)
        }
    )
}
