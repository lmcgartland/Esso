//
//  CustomSegmentView.swift
//  Esso
//
//  Created by Nathan Wallace on 4/21/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

import Cocoa

class CustomTextField : NSTextField {
    override func hitTest(aPoint: NSPoint) -> NSView? {
        return nil
    }
}

class CustomSegmentView: NSView {

    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var label: CustomTextField!
    
    private var selected = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.wantsLayer = true
    }
    
    func setSelected(inSelected: Bool) {
//        if (selected) {
//            self.layer?.backgroundColor = CGColorCreateGenericRGB(0, 0, 0.2, 1)
//        } else {
//            self.layer?.backgroundColor = CGColorGetConstantColor(kCGColorClear)
//        }
        
        self.selected = inSelected;
        self.setNeedsDisplayInRect(self.bounds)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        if (selected) {
            if let gradient = NSGradient(startingColor: NSColor(calibratedRed: 0.278, green: 0.835, blue: 0.933, alpha: 1), endingColor: NSColor(calibratedRed: 0.251, green: 0.647, blue: 0.922, alpha: 1))
            {
                gradient.drawInRect(self.bounds, angle: 270)
            }
            self.label.textColor = NSColor.whiteColor()
        } else {
            self.label.textColor = NSColor.blackColor()
        }
    }
    
}
