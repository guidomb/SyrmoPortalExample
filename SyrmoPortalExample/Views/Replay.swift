//
//  Replay.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import Portal

public func replayView(replay: Image?, height: UInt) -> Component<Syrmo.Action> {
    if let replay = replay {
        return container(
            children: [
                imageView(image: replay),
                fullscreenLabel()
            ]
        )
    } else {
        return container(
            children:[
                loaderView(),
                label(
                    text: "Loading replay ...",
                    style: labelStyleSheet() { base, label in
                        base.backgroundColor = .black
                        label.textColor = .white
                        label.textSize = 12
                        label.textFont = Montserrat.regular
                        label.textAlignment = .center
                    }
                )
            ],
            style: styleSheet() {
                $0.backgroundColor = .black
            },
            layout: layout() {
                $0.height = Dimension(value: height)
                $0.justifyContent = .center
                $0.alignment = alignment() {
                    $0.items = .center
                }
            }
        )
    }
}

fileprivate func fullscreenLabel() -> Component<Syrmo.Action> {
    return container(
        children: [
            label(
                text: "FULLSCREEN",
                style: labelStyleSheet() { base, label in
                    label.textColor = .white
                    label.textSize = 12
                    label.textFont = Montserrat.regular
                    label.textAlignment = .center
                }
            ),
            imageView(
                image: Image.localImage(named: "Fullscreen"),
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
            $0.alignment = alignment() {
                $0.items = .center
            }
        }
    )
}

fileprivate func loaderView() -> Component<Syrmo.Action> {
    return imageView(
        image: Image.localImage(named: "Loader"),
        style: styleSheet() {
            $0.backgroundColor = .black
        },
        layout: layout() {
            $0.width = Dimension(value: 35)
            $0.height = Dimension(value: 35)
        }
    )
    
}
