//
//  Routes.swift
//  JukeBox
//
//  Created by Maëva Bouvard on 24/06/2024.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("Hi") { req -> String in
        return "Welcome !"
    }

    app.post("signup") { req -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
}
