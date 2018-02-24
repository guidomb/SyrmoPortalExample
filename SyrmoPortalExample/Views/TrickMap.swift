//
//  TrickMap.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import Portal


public func trickMapView(skateTrick: SkateTrick) -> Component<Syrmo.Action> {
    let placemark = MapPlacemark(
        coordinates: skateTrick.location.coordiantes,
        icon: .localImage(named: "Placemark")
    )

    return container(
        children: [
            mapView(
                properties: properties() {
                    $0.placemarks = [placemark]
                    $0.isZoomEnabled = false
                    $0.zoomLevel = 0.002
                    $0.isScrollEnabled = false
                    $0.center = placemark.coordinates
                },
                style: styleSheet() {
                    $0.cornerRadius = 5
                },
                layout: layout() {
                    $0.flex = flex() {
                        $0.grow = .one
                        $0.direction = .row
                    }
                    $0.margin = .all(value: 10)
                }
            )
        ],
        style: styleSheet() {
            $0.backgroundColor = .white
        },
        layout: layout() {
            $0.flex = flex() {
                $0.grow = .four
            }
            $0.justifyContent = .center
        }
    )
}
