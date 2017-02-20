//
//  NavigationBar.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import PortalView

public func syrmoNavigationBar() -> NavigationBar<Message> {
    return navigationBar(
        properties: properties(
            title: .image(UIImageContainer.loadImage(named: "NavbarLogo")!),
            hideBackButtonTitle: true
        ),
        style: navigationBarStyleSheet() { base, navBar in
            base.backgroundColor = ColorPalette.Secondary.color05
            navBar.isTranslucent = false
            navBar.tintColor = Color.white
            navBar.titleTextColor = Color.white
            navBar.titleTextFont = Montserrat.regular
            navBar.statusBarStyle = .lightContent
        }
    )
}
