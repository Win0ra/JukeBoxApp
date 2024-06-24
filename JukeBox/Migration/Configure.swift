//
//  Configure.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 24/06/2024.
//

import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) throws {
    // Configure MySQL database
    app.databases.use(.mysql(
        hostname: "localhost",
        username: "root",
        password: "password",
        database: "jukebox"
    ), as: .mysql)

    // Configure migrations
    app.migrations.add(CreateUser())

    // Register routes
    try routes(app)
}
