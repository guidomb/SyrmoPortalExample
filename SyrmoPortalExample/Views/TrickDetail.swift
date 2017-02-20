//
//  TrickDetail.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import PortalView

public func skateTrickDetailView(skateTrick: SocialInteractive<SkateTrick>, screenWidth: UInt = UInt(getScreenSize().width), height: UInt = getDetailReplayImageHeight(), using bundle: Bundle = .main) -> Component<Message> {
    return container(
        children: [
            header(skateTrick: skateTrick.object),
            replayView(replay: skateTrick.object.replay, height: height, using: bundle),
            trickNameView(name: skateTrick.object.name),
            statsView(stats: skateTrick.object.stats, screenWidth: screenWidth),
            trickMapView(skateTrick: skateTrick.object, using: bundle),
            socialActionBar(forElement: skateTrick, using: bundle).map { .socialAction(action: $0) }
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .column
                $0.grow = .one
            }
            $0.aligment = aligment() {
                $0.items = .stretch
            }
        }
    )
}
