//
//  DataConstants.swift
//  QuatroBingo
//
//  Created by Lua Ferreira de Carvalho on 30/05/25.
//

import Dependencies
import FirebaseFirestore

extension Firestore: @retroactive TestDependencyKey {}
extension Firestore: @retroactive DependencyKey {
    public static var liveValue: Firestore {
        .firestore()
    }
}
