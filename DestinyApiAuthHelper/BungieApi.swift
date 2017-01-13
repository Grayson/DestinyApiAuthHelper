//
//  BungieApi.swift
//  DestinyApiAuthHelper
//
//  Created by Grayson Hansard on 1/11/17.
//  Copyright © 2017 From Concentrate Software. All rights reserved.
//

import Foundation

class BungieApi {
	static let shared: BungieApi = { BungieApi() }()

	private struct BungieUrls {
		private init() {}
		static let GetAccessTokens = URL(string: "https://www.bungie.net/Platform/App/GetAccessTokensFromCode/")!
	}

	typealias FetchAccessTokensCallback = ((access: TokenDto, refresh: TokenDto)) -> ()
	func fetchAccessTokens(apiKey: String, code: String, callback: @escaping FetchAccessTokensCallback) {
		let json = try! JSONSerialization.data(withJSONObject: [ "code": code ])

		let request = NSMutableURLRequest(url: BungieUrls.GetAccessTokens)
		request.httpMethod = "POST"
		request.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("\(json.count)", forHTTPHeaderField: "Content-Length")
		request.httpBody = json

		let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
			let jsonResponse: [AnyHashable: Any] = try! JSONSerialization.jsonObject(with: data!) as! [AnyHashable : Any]
			guard
				let responseJson = jsonResponse["Response"] as? [AnyHashable: Any],
				let accessTokenJson = responseJson["accessToken"] as? [AnyHashable : Any],
				let refreshTokenJson = responseJson["refreshToken"] as? [AnyHashable : Any],
				let accessToken = TokenDto.fromJson(json: accessTokenJson),
				let refreshToken = TokenDto.fromJson(json: refreshTokenJson)
			else {
				print(String(data: data!, encoding: String.Encoding.utf8)!)
				return
			}
			callback( (accessToken, refreshToken) )
		})
		task.resume()
	}
}
