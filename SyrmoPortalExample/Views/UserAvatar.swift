//
//  UserAvatar.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import PortalView

public func userAvatarView(avatar: Image?) -> Component<Message> {
    if let avatar = avatar {
        return imageView(
            image: avatar,
            layout: layout() {
                $0.height = Dimension(value: 34)
                $0.width = Dimension(value: 34)
                $0.aligment = aligment() {
                    $0.`self` = .center
                }
            }
        )
    } else {
        return container(
            children: [],
            style: styleSheet() {
                $0.backgroundColor = .black
            },
            layout: layout() {
                $0.height = Dimension(value: 34)
                $0.width = Dimension(value: 34)
                $0.aligment = aligment() {
                    $0.`self` = .center
                }
            }
        )
    }
}
