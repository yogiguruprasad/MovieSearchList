//
//  Callback.swift
//  MovieCollection
//
//  Created by Guru on 26/10/20.
//

import Foundation

public class Callback<T, V> {
    
    private let successBlock: (T) -> Void
    private let failureBlock: (V) -> Void
    
    public init(onSuccess: @escaping (T) -> Void, onFailure: @escaping (V) -> Void) {
        self.successBlock = onSuccess
        self.failureBlock = onFailure
    }
    
    public func onSuccess(_ successResponse: T) {
        successBlock(successResponse)
    }
    
    public func onFailure(_ failureResponse: V) {
        failureBlock(failureResponse)
    }
    
}
