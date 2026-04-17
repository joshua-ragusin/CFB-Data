//
//  InjectionKey.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/24/25.
//

public protocol InjectionKey {
    associatedtype Value
    
    static var currentValue: Self.Value { get set }
}
