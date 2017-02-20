//
//  Replay.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import PortalView

public func replayView(replay: Image?, height: UInt, using bundle: Bundle) -> Component<Message> {
    if let replay = replay {
        return container(
            children: [
                imageView(image: replay),
                fullscreenLabel(bundle: bundle)
            ]
        )
    } else {
        return container(
            children:[
                loaderView(using: bundle),
                label(
                    text: "Loading replay ...",
                    style: labelStyleSheet() { base, label in
                        base.backgroundColor = .black
                        label.textColor = .white
                        label.textSize = 12
                        label.textFont = Montserrat.regular
                        label.textAligment = .center
                    }
                )
            ],
            style: styleSheet() {
                $0.backgroundColor = .black
            },
            layout: layout() {
                $0.height = Dimension(value: height)
                $0.justifyContent = .center
                $0.aligment = aligment() {
                    $0.items = .center
                }
            }
        )
    }
}

fileprivate func fullscreenLabel(bundle: Bundle) -> Component<Message> {
    return container(
        children: [
            label(
                text: "FULLSCREEN",
                style: labelStyleSheet() { base, label in
                    label.textColor = .white
                    label.textSize = 12
                    label.textFont = Montserrat.regular
                    label.textAligment = .center
                }
            ),
            imageView(
                image: UIImageContainer.loadImage(named: "Fullscreen", from: bundle)!,
                style: styleSheet(),
                layout: layout() {
                    $0.width = Dimension(value: 20)
                    $0.height = Dimension(value: 20)
                }
            )
        ],
        style: styleSheet(),
        layout: layout() {
            $0.flex = flex() {
                $0.direction = .row
            }
            $0.position = .absolute(forEdge: edge() {
                $0.bottom = 10
                $0.right = 10
            })
            $0.height = Dimension(value: 30)
            $0.width = Dimension(value: 100)
            $0.aligment = aligment() {
                $0.items = .center
            }
        }
    )
}

fileprivate func loaderView(using bundle: Bundle) -> Component<Message> {
    if let loaderImage = UIImageContainer.loadImage(named: "Loader", from: bundle) {
        return imageView(
            image: loaderImage,
            style: styleSheet() {
                $0.backgroundColor = .black
            },
            layout: layout() {
                $0.width = Dimension(value: 35)
                $0.height = Dimension(value: 35)
            }
        )
    } else {
        return container(
            children: [],
            style: styleSheet() {
                $0.backgroundColor = .red
            },
            layout: layout() {
                $0.width = Dimension(value: 35)
                $0.height = Dimension(value: 35)
            }
        )
    }
}
