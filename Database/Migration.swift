//
//  Migration.swift
//  CFB-Data
//
//  Created by Joshua Ragusin on 10/22/25.
//
import GRDB

protocol Migration {
    var name: String { get }
    
    @Sendable
    func migrate(_ db: Database) throws
}
