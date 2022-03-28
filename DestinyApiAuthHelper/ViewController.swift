//
//  ViewController.swift
//  DestinyApiAuthHelper
//
//  Created by Grayson Hansard on 1/11/17.
//  Copyright © 2017 From Concentrate Software. All rights reserved.
//

import Cocoa

private func convertToDate(_ value: Int) -> String {
	return ViewController.dateFormatter.string(from: Date(timeIntervalSinceNow: TimeInterval(value)))
}

class ViewController: NSViewController {

	static let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		return formatter
	}()

	struct ViewModel {
		let accessTokenValue: String
		let accessTokenExpiration: String
		let accessTokenReady: String
		let refreshTokenValue: String
		let refreshTokenExpiration: String
		let refreshTokenReady: String
	}

	@IBOutlet weak var authTokenField: NSTextField?
	@IBOutlet weak var refreshTokenField: NSTextField?
	@IBOutlet weak var apiKeyTextField: NSTextField? {
		didSet {
			guard let textField = apiKeyTextField else { return }
			if textField.stringValue.isEmpty {
				textField.stringValue = UserDefaults.standard.string(forKey: "ApiKey") ?? ""
			}
			textField.action = #selector(saveApiKey(_:))
		}
	}

	@IBAction func saveApiKey(_ sender: Any) {
		guard let apiKey = apiKeyTextField?.stringValue else { return }
		UserDefaults.standard.set(apiKey, forKey: "ApiKey")
	}

	@IBAction func openApplicationPage(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://www.bungie.net/en/Application/")!)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		URLHandler.singleton.onCodeReceived = { [weak self] code in
			guard let apiKey = self?.apiKeyTextField?.stringValue else { return }
			BungieApi.shared.fetchAccessTokens(apiKey: apiKey, code: code) { (accessToken, refreshToken) in
				self?.representedObject = ViewModel(
					accessTokenValue: accessToken.value,
					accessTokenExpiration: convertToDate(accessToken.expires),
					accessTokenReady: convertToDate(accessToken.readyin),
					refreshTokenValue: refreshToken.value,
					refreshTokenExpiration: convertToDate(refreshToken.expires),
					refreshTokenReady: convertToDate(refreshToken.expires)
				)
			}
		}
	}

	override var representedObject: Any? {
		didSet {
			guard
				let vm = representedObject as? ViewModel,
				let authTokenField = authTokenField,
				let refreshTokenField = refreshTokenField
			else { return }

			authTokenField.stringValue = vm.accessTokenValue
			refreshTokenField.stringValue = vm.refreshTokenValue
		}
	}

}

