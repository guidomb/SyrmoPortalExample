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
        case dumb
        case imageFetched(image: Image, remote: RemoteImage)
        case imageFetchError(image: RemoteImage, error: Error)
        case socialAction(action: SocialActionMessage<SkateTrick>)
        case show(trick: ObjectID<SkateTrick>)
        case commentsAlertDismissed
        
    }
    
    public enum State {
        
        case idle
        case feedLoaded(skateTricks: [SocialInteractive<SkateTrick>], trickNeedsCommentsAlert: SocialInteractive<SkateTrick>?)
        
    }
    
    public enum Route: Portal.Route {
        
        case main
        
        public var previous: Syrmo.Route? {
            return .none
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
    
    var initialRoute: Syrmo.Route { return .main }
    
    func translateRouteChange(from currentRoute: Syrmo.Route, to nextRoute: Syrmo.Route) -> Syrmo.Message? {
        return .none
    }
    
    func update(state: Syrmo.State, message: Syrmo.Message) -> (Syrmo.State, Syrmo.Command?)? {
        print("Message received: \(message)")
        switch (state, message) {
            
        case (.idle, .applicationStarted):
            return  (.feedLoaded(skateTricks: feedItems(itemsCount: 20), trickNeedsCommentsAlert: .none), .none)
            
        case (.feedLoaded(var skateTricks, .none), .socialAction(let socialAction)):
            switch socialAction {
                
            case .like(let skateTrickId):
                var (index, skateTrick) = skateTricks.findBy(id: skateTrickId)!
                skateTrick.likedByMe = !skateTrick.likedByMe
                skateTrick.likesCount = skateTrick.likedByMe ? skateTrick.likesCount + 1 : skateTrick.likesCount - 1
                skateTricks[index] = skateTrick
                return (.feedLoaded(skateTricks: skateTricks, trickNeedsCommentsAlert: .none), .none)
                
            case .showComments(let skateTrickId):
                let (_, skateTrick) = skateTricks.findBy(id: skateTrickId)!
                return (.feedLoaded(skateTricks: skateTricks, trickNeedsCommentsAlert: skateTrick), .none)
                
            }
            
        case (.feedLoaded(let skateTricks, .some(_)), .commentsAlertDismissed):
            return (.feedLoaded(skateTricks: skateTricks, trickNeedsCommentsAlert: .none), .none)
            
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
            
        case .feedLoaded(let skateTricks, .none):
            return createFeedView(items: skateTricks)
            
        case .feedLoaded(_, .some(let skateTrick)):
            return Syrmo.View(
                navigator: .main,
                root: .stack(syrmoNavigationBar()),
                alert: AlertProperties(
                    title: "Social action triggered!",
                    text: "Skate trick with ID '\(skateTrick.object.id.value)' has \(skateTrick.commentsCount) comments",
                    button: AlertProperties.Button(title: "OK", onTap: .sendMessage(.commentsAlertDismissed))
                )
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

