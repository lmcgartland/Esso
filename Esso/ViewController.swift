//
//  ViewController.swift
//  Esso
//
//  Created by Luke McGartland on 4/12/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

import Cocoa
import Quartz

class ViewController: NSViewController {

    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let pdfDoc = PDFDocument(URL: NSURL(fileURLWithPath: "/Users/Nathan/Downloads/310 Project 1 Assignment Details.pdf"))
        pdfView.setDocument(pdfDoc)
        
        pdfView.setBackgroundColor(NSColor.clearColor())
        pdfView.setDisplayBox(kPDFDisplayBoxMediaBox)
        pdfView.setDisplaysPageBreaks(false)
        pdfView.setAutoScales(true)
        
        pdfThumbnailView.setBackgroundColor(NSColor.clearColor())
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

