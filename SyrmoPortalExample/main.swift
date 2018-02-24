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
        
    }
    
    public enum State {
        
        case idle
        
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
        return .none
    }
    
    func view(for state: Syrmo.State) -> Syrmo.View {
        let skateTricks = feedItems(itemsCount: 20)
        return createFeedView(items: skateTricks)
    }
    
    func subscriptions(for state: Syrmo.State) -> [Subscription<Syrmo.Message, Syrmo.Route, Syrmo.Subscription>] {
        return []
    }
    
}

let context = UIKitApplicationContext(
    application: Application(),
    commandExecutor: CommandExecutor(),
    subscriptionManager: SubscriptionManager(),
    rendererFactory: VoidCustomComponentRenderer.init
)

PortalUIApplication.start(applicationContext: context) { message in
    switch message {
    case .didFinishLaunching(_, _):
        return .applicationStarted
    default:
        return .none
    }
}

