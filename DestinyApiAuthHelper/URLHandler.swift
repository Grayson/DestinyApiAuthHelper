//
//  URLHandler.swift
//  DestinyApiAuthHelper
//
//  Created by Grayson Hansard on 1/11/17.
//  Copyright © 2017 From Concentrate Software. All rights reserved.
//

import Foundation

class URLHandler {
	static let singleton: URLHandler = { URLHandler() }()

	typealias CodeReceivedCallback = (String) -> ()
	var onCodeReceived: CodeReceivedCallback = { _ in }

	private init() {
		NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(URLHandler.handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
	}

	@objc func handleGetURLEvent(_ event: NSAppleEventDescriptor, withReplyEvent replyEvent: NSAppleEventDescriptor) {
		for itemIndex in 0..<event.numberOfItems {
			guard
				let descriptor = event.atIndex(itemIndex+1),
				let urlComponents = URLComponents(string: descriptor.stringValue ?? ""),
				let code = (urlComponents.queryItems?.first { $0.name == "code" })?.value
			else { continue }

			onCodeReceived(code)
		}
	}
}
