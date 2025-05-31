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

extension Firestore.Decoder: @retroactive TestDependencyKey {}
extension Firestore.Decoder: @retroactive DependencyKey {
    public static var liveValue: Firestore.Decoder {
        let d = Firestore.Decoder()
        d.dateDecodingStrategy = .iso8601
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }
}

extension Firestore.Encoder: @retroactive TestDependencyKey {}
extension Firestore.Encoder: @retroactive DependencyKey {
    public static var liveValue: Firestore.Encoder {
        let e = Firestore.Encoder()
        e.dateEncodingStrategy = .iso8601
        e.keyEncodingStrategy = .convertToSnakeCase
        return e
    }
}

