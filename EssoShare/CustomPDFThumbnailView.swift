//
//  CustomPDFThumbnailView.swift
//  Esso
//
//  Created by Luke McGartland on 4/18/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//
import Cocoa
import Foundation
import Quartz

class CustomPDFThumbnailView: PDFThumbnailView {
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setBackgroundColor(NSColor.clearColor())
        addBehavior()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBehavior()
    }
    
    func addBehavior (){
        Swift.print("Add all the behavior here")
    }
}