//
//  Syrmo.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit
import Portal

public enum Device {
    
    private static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && getScreenSize().height < 568.0
    private static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && getScreenSize().height == 568.0
    private static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && getScreenSize().height == 667.0
    private static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && getScreenSize().height == 736.0
    private static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && getScreenSize().height == 1024.0
    private static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && getScreenSize().height == 1366.0
    
    case iPhone5S
    case iPhone6
    case iPhone6P
    case anotherDevice
    
    public init() {
        if Device.IS_IPHONE_5 {
            self = .iPhone5S
        } else if Device.IS_IPHONE_6 {
            self = .iPhone6
        } else if Device.IS_IPHONE_6P {
            self = .iPhone6P
        } else {
            self = .anotherDevice
        }
    }
    
}

public func getDetailReplayImageURL() -> URL {
    switch Device() {
    case .iPhone5S:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_detail_x1.gif")!
    case .iPhone6:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_detail_x2.gif")!
    case .iPhone6P:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_detail_x3.gif")!
    case .anotherDevice:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_detail_x3.gif")!
    }
}

public func getDetailReplayImageHeight() -> UInt {
    switch getScreenSize().width {
    case 320:
        return 205
    case 375:
        return 271
    case 414:
        return 317
    default:
        return 317
    }
}

public func getReplayImageURL() -> URL {
    switch Device() {
    case .iPhone5S:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_x1.gif")!
    case .iPhone6:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_x2.gif")!
    case .iPhone6P:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_x3.gif")!
    case .anotherDevice:
        return URL(string: "https://s3.amazonaws.com/syrmo-docs/replay/skate_trick_x3.gif")!
    }
}

public func getReplayImageHeight() -> UInt {
    return 140
}

public func getScreenSize() -> CGSize {
    return UIScreen.main.bounds.size
}


public func model(replayImage: Image? = .none) -> SocialInteractive<SkateTrick> {
    let avatar = UIImage(named: "GuidoMBAvatar.jpg")
        .flatMap { $0.createSyrmoImageProfile() }
        .flatMap { UIImageJPEGRepresentation($0, 1.0) }!
    let skateTrick = SkateTrick(
        id: ObjectID(value: "1"),
        name: "Flip varial",
        stats: SkateTrickStats(
            height: 452.81,
            distance: 132.45,
            airTime: 0.234,
            popForce: 313.31
        ),
        location: Location(
            name: "San Francisco, California",
            coordiantes: Coordinates(latitude: -34.591522, longitude: -58.442705)
        ),
        replay: replayImage,
        createdBy: User(
            id: ObjectID(value: "Knn1yD6Hq9"),
            name: "Guido Marucci Blas",
            avatar: Image.blob(data: avatar)
        ),
        createdAt: Date())
    
    return SocialInteractive(object: skateTrick, commentsCount: 12, likesCount: 36, likedByMe: false)
}

public func feedItems(itemsCount: UInt) -> [SocialInteractive<SkateTrick>] {
    let trickNames = [
        "Flip varial",
        "Kickflip",
        "Pop shove it",
        "Heelflip",
        "360 Ollie",
        "Impossible"
    ]
    
    return (0 ..< itemsCount).map { index in
        let avatar = UIImage(named: "GuidoMBAvatar.jpg")
            .flatMap { $0.createSyrmoImageProfile() }
            .flatMap { UIImageJPEGRepresentation($0, 1.0) }!
        let skateTrick = SkateTrick(
            id: ObjectID(value: "\(index)"),
            name: trickNames.sample(),
            stats: SkateTrickStats(
                height: 452.81,
                distance: 132.45,
                airTime: 0.234,
                popForce: 313.31
            ),
            location: Location(
                name: "San Francisco, California",
                coordiantes: Coordinates(latitude: -34.591522, longitude: -58.442705)
            ),
            replay: .none,
            createdBy: User(
                id: ObjectID(value: "Knn1yD6Hq9"),
                name: "Guido Marucci Blas",
                avatar: Image.blob(data: avatar)
            ),
            createdAt: Date())
        
        return SocialInteractive(
            object: skateTrick,
            commentsCount: UInt(arc4random_uniform(100)),
            likesCount: UInt(arc4random_uniform(100)),
            likedByMe: false
        )
    }
}

public func createDetailView(model: SocialInteractive<SkateTrick>) -> (RootComponent<Syrmo.Action>, Component<Syrmo.Action>) {
    return (.stack(syrmoNavigationBar()), skateTrickDetailView(skateTrick: model))
}

public func createFeedView(items: [SocialInteractive<SkateTrick>]) -> Syrmo.View {
    
    let tableItems = items.map { item in
        tableItem(
            height: skateTrickViewHeight,
            onTap: .sendMessage(.show(trick: item.object.id)),
            selectionStyle: .none
        ) { _ in
            TableItemRender(
                component: skateTrickView(skateTrick: item),
                typeIdentifier: "SkateTrickFeedItem"
            )
        }
    }
    
    let component: Component<Syrmo.Action> = table(
        properties: properties() {
            $0.items = tableItems
            $0.showsVerticalScrollIndicator = false
        },
        style: tableStyleSheet() { base, table in
            base.backgroundColor = ColorPalette.Secondary.color04
        },
        layout: layout() {
            $0.flex = flex() {
                $0.grow = .one
            }
        }
    )

    return Syrmo.View(
        navigator: .main,
        root: .stack(syrmoNavigationBar()),
        component: component
    )
}

let root = createDetailView(model: model())

public func fetchReplayImage(render: @escaping (Component<Syrmo.Action>) -> ()) {
    let task = URLSession.shared.dataTask(with: getDetailReplayImageURL()) { data, _, error in
        if let error = error {
            print("Image could not be fetched: \(error)")
            return
        }
        guard let imageData = data else {
            print("Image data not available")
            return
        }
        DispatchQueue.main.sync {
            let image = Image.blob(data: imageData)
            let component = skateTrickDetailView(skateTrick: model(replayImage: image))
            render(component)
        }
        
    }
    task.resume()
}

