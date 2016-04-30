//
//  ShareViewController.swift
//  EssoShare
//
//  Created by Luke McGartland on 4/12/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

import Cocoa
import Quartz

enum EssoFilter {
    case None
    case BlackWhite
    case Eco
}

class ShareViewController: NSViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var controlsView: NSView!
    @IBOutlet weak var pdfThumbnailView: PDFView!
    
    @IBOutlet weak var filterSegmentNone: CustomSegmentView!
    @IBOutlet weak var filterSegmentBW: CustomSegmentView!
    @IBOutlet weak var filterSegmentEco: CustomSegmentView!
    
    @IBOutlet weak var copiesLabel: NSTextField!
    @IBOutlet weak var pagesLabel: NSTextField!

    
    var copies = 1;
    var pages = 0;


    override var nibName: String? {
        return "ShareViewController"
    }

    override func loadView() {
        super.loadView()

    
        // Insert code here to customize the view
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
        if let attachments = item.attachments {
            NSLog("Attachments = %@", attachments as NSArray)
        } else {
            NSLog("No Attachments")
        }
    
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var f = self.view.frame;
        f.size.width = 700;
        f.size.height = 550;
        self.view.frame = f;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.actOnSpecialNotification), name:
            PDFViewPageChangedNotification, object: self.pdfView)

        self.pdfView.setShouldAntiAlias(true)
        self.pdfView.setDisplaysPageBreaks(true)
        self.pdfView.setInterpolationQuality(kPDFInterpolationQualityLow)
        
        
        // Do any additional setup after loading the view.
        let myExtensionContext = self.extensionContext
        /*if let items = myExtensionContext?.inputItems {
            /*for obj in items {
                //print("Object: \(obj.attributedTitle)")
            }*/
        }*/
        let extensionItem = myExtensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        controlsView.layer?.backgroundColor = NSColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        pdfView.setBackgroundColor(NSColor.clearColor())
        //pdfView.takeBackgroundColorFrom(<#T##sender: AnyObject!##AnyObject!#>)
        pdfView.setDisplayBox(kPDFDisplayBoxMediaBox)
        pdfView.setDisplaysPageBreaks(false)
        pdfView.setAutoScales(true)
        
        
        pdfThumbnailView.setDisplayMode(kPDFInterpolationQualityLow)
        pdfThumbnailView.setBackgroundColor(NSColor.clearColor())
        pdfThumbnailView.setDisplaysPageBreaks(false)
        pdfThumbnailView.setAutoScales(true)

        
        itemProvider.loadItemForTypeIdentifier("com.adobe.pdf", options: nil) { [unowned self] (result: NSSecureCoding?, error: NSError!) -> Void in
            if let data = result as? NSData {
                dispatch_async(dispatch_get_main_queue(),{
                    let pdfDoc = PDFDocument(data: data)
                    let thumbnailDoc = PDFDocument(data: data)
                    self.pages = pdfDoc.pageCount()
                    self.pdfView.setDocument(pdfDoc)
                    self.pdfThumbnailView.setDocument(thumbnailDoc)
                    self.updateLabels()
                })
            }
            
        }
        
        
        
        
        
        //let subview = pdfThumbnailView.subviews[0] as! NSScrollView
        //subview.hasVerticalScroller = false
        //subview.drawsBackground = false
        //subview.contentView.backgroundColor = NSColor(colorLiteralRed: 1, green: 0, blue: 0, alpha: 0)
        //subview.contentView.subviews[0].layer?.backgroundColor = NSColor(colorLiteralRed: 0.5, green: 0, blue: 0, alpha: 1).CGColor
        //pdfThumbnailView.setBackgroundColor(NSColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0))
        
    }

    func setFilter(filter: EssoFilter) {
        switch filter {
        case .None:
            print("None")
        case .BlackWhite:
            print("BlackWhite")
        case .Eco:
            print("Eco")
        }
    }
    
    @IBAction func segmentSelected(sender: NSButton?) {
        print("Some button pressed")
        if let selectedSegment = sender {
            if selectedSegment == self.filterSegmentNone.button {
                self.setFilter(.None)
            } else if selectedSegment == self.filterSegmentBW.button {
                self.setFilter(.BlackWhite)
            } else if selectedSegment == self.filterSegmentEco.button {
                self.setFilter(.Eco)
            }
        }
    }

    
    @IBAction func send(sender: AnyObject?) {
        let outputItem = NSExtensionItem()
        // Complete implementation by setting the appropriate value on the output item
    
        let outputItems = [outputItem]
        self.extensionContext!.completeRequestReturningItems(outputItems, completionHandler: nil)
    }

    @IBAction func cancel(sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequestWithError(cancelError)
    }
    
    
    @IBAction func increaseCopies(sender: NSButton?) {
        print("Increase button pressed")
        copies = copies + 1;
        self.updateLabels()
    }
    @IBAction func decreaseCopies(sender: NSButton?) {
        print("Decrease button pressed")
        copies = copies - 1;
        self.updateLabels()
    }
    @IBAction func sendToPrinter(sender: NSButton?) {
        print("Print button pressed")
    }
    
    func updateLabels(){
        let numPages = copies*pages;
        if copies == 1 {
            copiesLabel.stringValue = String(copies) + " copy";
        }else{
            copiesLabel.stringValue = String(copies) + " copies";
        }
        if numPages == 1 {
            pagesLabel.stringValue = String(numPages) + " page";
        }else{
            pagesLabel.stringValue = String(numPages) + " pages";
        }
    }
    func actOnSpecialNotification(){
        print("change")
        let currentPage = self.pdfView.currentDestination()
        self.pdfThumbnailView.goToDestination(currentPage)
    }

}
