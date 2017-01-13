//
//  StepView.swift
//  DestinyApiAuthHelper
//
//  Created by Grayson Hansard on 1/12/17.
//  Copyright © 2017 From Concentrate Software. All rights reserved.
//

import AppKit

@IBDesignable
class StepView : NSView {

	@IBInspectable var text: String = "1"
	@IBInspectable var textSize: Float = 24.0
	@IBInspectable var textColor: NSColor = NSColor.black
	@IBInspectable var circleColor: NSColor = NSColor.black
	@IBInspectable var circleBackgroundColor: NSColor = NSColor.clear
	@IBInspectable var circleThickness: Float = 1.0

	override func draw(_ dirtyRect: NSRect) {
		let thicknessFloat = CGFloat(circleThickness)
		let adjustedRect = bounds.insetBy(dx: thicknessFloat, dy: thicknessFloat)
		let circle = NSBezierPath(ovalIn: adjustedRect)
		circle.lineWidth = thicknessFloat
		circleBackgroundColor.set()
		circle.fill()
		circleColor.set()
		circle.stroke()

		let font = NSFont.systemFont(ofSize: CGFloat(textSize))
		let attributes: [String : Any] = [
			NSForegroundColorAttributeName: textColor,
			NSFontAttributeName: font
		]
		let attributedString = NSAttributedString(string: text, attributes: attributes)
		let stringSize = attributedString.size()
		let stringRect = NSRect(
			x: (adjustedRect.width - stringSize.width) / 2.0,
			y: (adjustedRect.height - stringSize.height) / 2.0,
			width: stringSize.width,
			height: stringSize.height
		)

		attributedString.draw(in: stringRect)
	}
}
