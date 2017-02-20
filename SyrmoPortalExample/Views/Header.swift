//
//  Header.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import PortalView

internal let headerHeight: UInt = 39

public func header(skateTrick: SkateTrick) -> Component<Message> {
    let user = skateTrick.createdBy

    let nameAndLocation: Component<Message> = container(
        children: [
            label(
                text: user.name,
                style: labelStyleSheet() { base, label in
                    base.backgroundColor = .white
                    label.textColor = ColorPalette.Secondary.color05
                    label.textSize = 12
                    label.textFont = Montserrat.regular
                },
                layout: layout() {
                    $0.flex = flex() {
                        $0.grow = .one
                    }
                    $0.justifyContent = .flexEnd
                }
            ),
            label(
                text: skateTrick.location.name,
                style: labelStyleSheet() { base, label in
                    base.backgroundColor = .white
                    label.textColor = ColorPalette.Secondary.color04
                    label.textSize = 10
                    label.textFont = Montserrat.regular
                },
                layout: layout() {
                    $0.flex = flex() {
                        $0.grow = .one
                    }
                    $0.justifyContent = .flexStart
                }
            )
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .column
                $0.grow = .four
            }
            $0.padding = .by(edge: edge() {
                $0.vertical = 5
                $0.left = 5
            })
        }
    )

    let createdAt: Component<Message> = label(
        text: skateTrick.createdAt.timeAgo,
        style: labelStyleSheet() { base, label in
            base.backgroundColor = .white
            label.textColor = ColorPalette.Secondary.color04
            label.textSize = 10
            label.textFont = Montserrat.regular
            label.textAligment = .right
        },
        layout: layout() {
            $0.flex = flex() {
                $0.grow = .one
            }
        }
    )

    return container(
        children:[
            userAvatarView(avatar: user.avatar),
            nameAndLocation,
            createdAt
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .row
            }
            $0.height = Dimension(value: headerHeight)
            $0.margin = .by(edge: edge() {
                $0.horizontal = 10
            })
        }

    )
}
