//
//  CaseService.swift
//  Cases
//
//  Created by Johan Torell on 2021-02-08.
//

import Foundation

// protocol a type exactly as the graphql type with the values you want
public protocol Claim {
    var id: String? { get }
}

public protocol ClaimsServiceProtocol {
    func getClaims(resultHandler: @escaping (Result<[Claim], Error>) -> Void)
}

internal struct ClaimsServiceMock: ClaimsServiceProtocol {
    func getClaims(resultHandler _: @escaping (Result<[Claim], Error>) -> Void) {}
}
