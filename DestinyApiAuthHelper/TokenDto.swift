//
//  TokenDto.swift
//  DestinyApiAuthHelper
//
//  Created by Grayson Hansard on 1/11/17.
//  Copyright © 2017 From Concentrate Software. All rights reserved.
//

import Foundation

struct TokenDto
{
	let expires: Int
	let readyin: Int
	let value: String

	static func fromJson(json: [AnyHashable: Any]) -> TokenDto? {
		guard
			let expires = json["expires"] as? Int,
			let readyin = json["readyin"] as? Int,
			let value = json["value"] as? String
		else { return nil }
		return TokenDto(expires: expires, readyin: readyin, value: value)
	}

	private init(expires: Int, readyin: Int, value: String) {
		self.expires = expires
		self.readyin = readyin
		self.value = value
	}
}
