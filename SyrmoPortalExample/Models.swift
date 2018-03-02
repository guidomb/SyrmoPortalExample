//
//  Models.swift
//  SyrmoPortalExample
//
//  Created by Guido Marucci Blas on 2/19/17.
//  Copyright © 2017 Guido Marucci Blas. All rights reserved.
//
import Foundation
import Portal

public struct ObjectID<ObjectType> {
    
    public let value: String
    
}

extension ObjectID: Equatable {
    
    public static func ==(lhs: ObjectID<ObjectType>, rhs: ObjectID<ObjectType>) -> Bool {
        return lhs.value == rhs.value
    }
    
}

public protocol Identifiable {
    
    var id: ObjectID<Self> { get }
    
}

public struct SkateTrickStats {
    
    public var height: Double
    public var distance: Double
    public var airTime: Double
    public var popForce: Double
    
}

public struct Location {
    
    public var name: String
    public var coordiantes: Coordinates
    
}

public struct User: Identifiable {
    
    public let id: ObjectID<User>
    public var name: String
    public var avatar: Image?
    
}

public enum RemoteImage {
    
    case userAvatar(url: URL)
    case skateTrickReplay(url: URL)
    
}

public struct SkateTrick: Identifiable {
    
    public let id: ObjectID<SkateTrick>
    public var name: String
    public var stats: SkateTrickStats
    public var location: Location
    public var replay: Image?
    public var createdBy: User
    public var createdAt: Date
    
}
