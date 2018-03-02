//
//  main.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/15/18.
//  Copyright © 2018 Guido Marucci Blas. All rights reserved.
//
import UIKit
import Portal

public struct Syrmo {
    
    public typealias Action = Portal.Action<Route, Message>
    public typealias View = Portal.View<Route, Message, Navigator>
    
    public enum Message {
        
        case applicationStarted
        case showFeed
        case dumb
        case imageFetched(image: Image, remote: RemoteImage)
        case imageFetchError(image: RemoteImage, error: Error)
        case socialAction(action: SocialActionMessage<SkateTrick>)
        case show(trick: ObjectID<SkateTrick>)
        case commentsAlertDismissed
        
    }
    
    public enum State {
        
        case idle
        case feed(FeedState)
        case trickDetail(skateTricks: [SocialInteractive<SkateTrick>], skateTrickIndex: Int)
        
    }
    
    public enum FeedState {
        
        case fetching
        case loaded(skateTricks: [SocialInteractive<SkateTrick>], trickNeedsCommentsAlert: SocialInteractive<SkateTrick>?)
        
    }
    
    public enum Route: Portal.Route, Equatable {
        
        case feed
        case trickDetail(id: ObjectID<SkateTrick>)
        
        public static func ==(lhs: Route, rhs: Route) -> Bool {
            switch (lhs, rhs) {
                
            case (.feed, .feed):
                return true
            
            case (.trickDetail(let leftTrickId), .trickDetail(let rightTrickId)) where leftTrickId == rightTrickId:
                return true
                
            default:
                return false
                
            }
        }
        
        public var previous: Syrmo.Route? {
            switch self {
                
            case .feed:
                return .none
                
            case .trickDetail:
                return .feed
                
            }
        }
        
    }
    
    public enum Command {}
    
    public enum Subscription {
        
        case foo
        
    }
    
    public enum Navigator {
        
        case main
        
    }
}

final class CommandExecutor: Portal.CommandExecutor {

    func execute(command: Syrmo.Command, dispatch: @escaping (Syrmo.Action) -> Void) {
        
    }
    
}

final class SubscriptionManager: Portal.SubscriptionManager {
    
    func add(subscription: Syrmo.Subscription, dispatch: @escaping (Syrmo.Action) -> Void) {
        
    }
    
    func remove(subscription: Syrmo.Subscription) {
        
    }
    
}

final class Application: Portal.Application {
    
    var initialState: Syrmo.State { return .idle }
    
    var initialRoute: Syrmo.Route { return .feed }
    
    func translateRouteChange(from currentRoute: Syrmo.Route, to nextRoute: Syrmo.Route) -> Syrmo.Message? {
        switch (currentRoute, nextRoute) {
            
        case (.feed, .trickDetail(let skateTrickId)):
            return .show(trick: skateTrickId)
            
        case (.trickDetail, .feed):
            return .showFeed
            
        default:
            return .none
            
        }
    }
    
    func update(state: Syrmo.State, message: Syrmo.Message) -> (Syrmo.State, Syrmo.Command?)? {
        print("Message received: \(message)")
        switch (state, message) {
            
        case (.idle, .applicationStarted):
            let state: Syrmo.State = .feed(
                .loaded(
                    skateTricks: feedItems(itemsCount: 20),
                    trickNeedsCommentsAlert: .none
                )
            )
            return  (state, .none)
            
        case (.feed(.loaded(var skateTricks, .none)), .socialAction(let socialAction)):
            switch socialAction {
                
            case .like(let skateTrickId):
                var (index, skateTrick) = skateTricks.findBy(id: skateTrickId)!
                skateTrick.likedByMe = !skateTrick.likedByMe
                skateTrick.likesCount = skateTrick.likedByMe ? skateTrick.likesCount + 1 : skateTrick.likesCount - 1
                skateTricks[index] = skateTrick
                return (.feed(.loaded(skateTricks: skateTricks, trickNeedsCommentsAlert: .none)), .none)
                
            case .showComments(let skateTrickId):
                let (_, skateTrick) = skateTricks.findBy(id: skateTrickId)!
                return (.feed(.loaded(skateTricks: skateTricks, trickNeedsCommentsAlert: skateTrick)), .none)
                
            }
            
        case (.feed(.loaded(let skateTricks, .none)), .show(let skateTrickId)):
            if let (skateTrickIndex, _) = skateTricks.findBy(id: skateTrickId) {
                return (.trickDetail(skateTricks: skateTricks, skateTrickIndex: skateTrickIndex), .none)
            }
            return .none
            
            
        case (.feed(.loaded(let skateTricks, .some(_))), .commentsAlertDismissed):
            return (.feed(.loaded(skateTricks: skateTricks, trickNeedsCommentsAlert: .none)), .none)
            
        case (.trickDetail(var skateTricks, let skateTrickIndex), .socialAction(let socialAction)):
            var skateTrick = skateTricks[skateTrickIndex]
            switch socialAction {
                
            case .like:
                skateTrick.likedByMe = !skateTrick.likedByMe
                skateTrick.likesCount = skateTrick.likedByMe ? skateTrick.likesCount + 1 : skateTrick.likesCount - 1
                skateTricks[skateTrickIndex] = skateTrick
                return (.trickDetail(skateTricks: skateTricks, skateTrickIndex: skateTrickIndex), .none)
                
            case .showComments:
                return .none
                
            }
            
        case (.trickDetail(let skateTricks, _), .showFeed):
            return (.feed(.loaded(skateTricks: skateTricks, trickNeedsCommentsAlert: .none)), .none)
            
        default:
            return .none
        }
    }
    
    func view(for state: Syrmo.State) -> Syrmo.View {
        switch state {
            
        case .idle:
            return Syrmo.View(
                navigator: .main,
                root: .stack(syrmoNavigationBar()),
                component: container()
            )
        
        case .feed(.fetching):
            return Syrmo.View(
                navigator: .main,
                root: .stack(syrmoNavigationBar()),
                component: container(
                    children: [
                        label(text: "Loading ...")
                    ]
                )
            )
            
        case .feed(.loaded(let skateTricks, .none)):
            return createFeedView(items: skateTricks)
            
        case .feed(.loaded(_, .some(let skateTrick))):
            return Syrmo.View(
                navigator: .main,
                root: .stack(syrmoNavigationBar()),
                alert: AlertProperties(
                    title: "Social action triggered!",
                    text: "Skate trick with ID '\(skateTrick.object.id.value)' has \(skateTrick.commentsCount) comments",
                    button: AlertProperties.Button(title: "OK", onTap: .sendMessage(.commentsAlertDismissed))
                )
            )
            
        case .trickDetail(let skateTricks, let skateTrickIndex):
            return Syrmo.View(
                navigator: .main,
                root: .stack(syrmoNavigationBar()),
                component: skateTrickDetailView(skateTrick: skateTricks[skateTrickIndex])
            )
            
        }
    }
    
    func subscriptions(for state: Syrmo.State) -> [Subscription<Syrmo.Message, Syrmo.Route, Syrmo.Subscription>] {
        return []
    }
    
}

extension Array where Element == SocialInteractive<SkateTrick> {
    
    func findBy(id: ObjectID<SkateTrick>) -> (Int, SocialInteractive<SkateTrick>)? {
        guard let index = self.index(where: { $0.object.id == id }) else { return .none }
        return (index, self[index])
    }
    
}

let context = UIKitApplicationContext(
    application: Application(),
    commandExecutor: CommandExecutor(),
    subscriptionManager: SubscriptionManager(),
    rendererFactory: VoidCustomComponentRenderer.init
)

context.registerMiddleware(TimeLogger { print("M - Logger: \($0)") })

PortalUIApplication.start(applicationContext: context) { message in
    switch message {
    case .didFinishLaunching(_, _):
        return .applicationStarted
    default:
        return .none
    }
}

