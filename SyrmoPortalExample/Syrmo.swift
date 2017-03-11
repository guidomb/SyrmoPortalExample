//
//  Syrmo.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//

import UIKit
import PortalView

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

func getDetailReplayImageURL() -> URL {
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

func getDetailReplayImageHeight() -> UInt {
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

func getReplayImageURL() -> URL {
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

func getReplayImageHeight() -> UInt {
    return 140
}

func getScreenSize() -> CGSize {
    return UIScreen.main.bounds.size
}


public func model(replayImage: Image? = .none, using bundle: Bundle = .main) -> SocialInteractive<SkateTrick> {
    let avatar = UIImage(named: "GuidoMBAvatar.jpg", in: bundle, compatibleWith: .none)?.createSyrmoImageProfile(using: bundle)
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
            avatar: avatar.map { UIImageContainer(image: $0) }
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
        let avatar = UIImage(named: "GuidoMBAvatar.jpg")?.createSyrmoImageProfile()
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
                avatar: avatar.map { UIImageContainer(image: $0) }
            ),
            createdAt: Date())
        
        return SocialInteractive(object: skateTrick, commentsCount: 12, likesCount: 36, likedByMe: false)
    }
}

public func createDetailView(model: SocialInteractive<SkateTrick>) -> (RootComponent<Message>, Component<Message>) {
    return (.stack(syrmoNavigationBar()), skateTrickDetailView(skateTrick: model))
}

public func createFeedView(items: [SocialInteractive<SkateTrick>]) -> (RootComponent<Message>, Component<Message>) {
    
    let tableItems = items.map { item in
        tableItem(
            height: skateTrickViewHeight,
            onTap: .show(trick: item.object.id),
            selectionStyle: .none
        ) { _ in
            TableItemRender(
                component: skateTrickView(skateTrick: item),
                typeIdentifier: "SkateTrickFeedItem"
            )
        }
    }
    
    let component: Component<Message> = table(
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

    return (.stack(syrmoNavigationBar()), component)
}

let root = createDetailView(model: model())

public func fetchReplayImage(render: @escaping (Component<Message>) -> ()) {
    let task = URLSession.shared.dataTask(with: getDetailReplayImageURL()) { data, _, error in
        if let error = error {
            print("Image could not be fetched: \(error)")
            return
        }
        if let image = data.flatMap({ UIImage(data: $0) }) {
            print("Rendering view")
            DispatchQueue.main.sync {
                let component = skateTrickDetailView(skateTrick: model(replayImage: UIImageContainer(image: image)))
                render(component)
            }
        } else {
            print("Data is not a valid image")
        }
        
    }
    task.resume()
}

public enum Message {
    
    case dumb
    case imageFetched(image: Image, remote: RemoteImage)
    case imageFetchError(image: RemoteImage, error: Error)
    case socialAction(action: SocialActionMessage<SkateTrick>)
    case show(trick: ObjectID<SkateTrick>)
    
}

