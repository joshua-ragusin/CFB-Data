//
//  InjectedValues.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

import Foundation

struct InjectedValues {
    private static var current = InjectedValues()
    
    static subscript<K>(key: K.Type) -> K.Value where K: InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

extension InjectedValues {
    var gameStore: GameStore {
        get { Self[GameStore.self] }
        set { Self[GameStore.self] = newValue }
    }
    
    var teamStore: TeamStore {
        get { Self[TeamStore.self] }
        set { Self[TeamStore.self] = newValue }
    }
    
    var matchupStore: MatchupStore {
        get { Self[MatchupStore.self] }
        set { Self[MatchupStore.self] = newValue }
    }
    
    var networkClient: NetworkClient {
        get { Self[NetworkClient.self] }
        set { Self[NetworkClient.self] = newValue }
    }
    
    var recordStore: RecordStore {
        get { Self[RecordStore.self] }
        set { Self[RecordStore.self] = newValue }
    }
    
    var metricsStore: MetricsStore {
        get { Self[MetricsStore.self] }
        set { Self[MetricsStore.self] = newValue }
    }
}
