//
//  BaseResponse.swift
//  Music-Project
//
//  Created by Ata Doruk on 13.01.2021.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let resultCount: Int
    let results: T
}

