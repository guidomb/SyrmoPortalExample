//
//  NavigationBar.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import Foundation
import Portal

public func syrmoNavigationBar() -> NavigationBar<Syrmo.Action> {
    return navigationBar(
        properties: properties() {
            $0.title = .image(.localImage(named: "NavbarLogo"))
            $0.backButtonTitle = ""
        },
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
