//
//  SocialActionBar.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//
import Portal
import UIKit

internal let socialActionBarHeight: UInt = 55

public struct SocialInteractive<ObjectType: Identifiable> {

    public let object: ObjectType
    public var commentsCount: UInt
    public var likesCount: UInt
    public var likedByMe: Bool

}

public enum SocialActionMessage<ObjectType> {

    case like(object: ObjectID<ObjectType>)
    case showComments(object: ObjectID<ObjectType>)

}

public func socialActionBar<ObjectType>(
    forElement element: SocialInteractive<ObjectType>,
    using bundle: Bundle) -> Component<SocialActionMessage<ObjectType>> {

    let buttonLayout = layout() {
        $0.flex = flex() {
            $0.grow = .one
        }
        $0.margin = .by(edge: edge() {
            $0.top = 1
        })
    }
    let buttonStyle = buttonStyleSheet() { base, button in
        base.backgroundColor = .white
        button.textColor = ColorPalette.Secondary.color04
        button.textSize = 10
        button.textFont = Montserrat.regular
    }

    return container(
        children: [
            button(
                properties: properties() {
                    $0.icon = .localImage(named: "Comment")
                    $0.text = "Comments (\(element.commentsCount))"
                    $0.onTap = .showComments(object: element.object.id)
                },
                style: buttonStyle,
                layout: buttonLayout
            ),
            button(
                properties: properties() {
                    $0.icon = .localImage(named: "LikeOff") // TODO remove coupling with UIKit
                    $0.text = "Likes (\(element.likesCount))"
                    $0.isActive = element.likedByMe
                    $0.onTap = .like(object: element.object.id)
                },
                style: buttonStyle,
                layout: buttonLayout
            )
        ],
        style: styleSheet() {
            $0.backgroundColor = ColorPalette.Primary.color04
        },
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .row
            }
            $0.height = Dimension(value: socialActionBarHeight)
            $0.justifyContent = .spaceBetween
        }
    )

}
