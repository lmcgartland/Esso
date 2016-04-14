//
//  ShareViewController.swift
//  EssoShare
//
//  Created by Luke McGartland on 4/12/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

import Cocoa
import Quartz

class ShareViewController: NSViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var pdfThumbnailView: PDFThumbnailView!

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
        
        // Do any additional setup after loading the view.
        
        let myExtensionContext = self.extensionContext
        if let items = myExtensionContext?.inputItems {
            for obj in items {
                print("Object: \(obj.attributedTitle)")
            }
        }
        
        let extensionItem = myExtensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        
        itemProvider.loadItemForTypeIdentifier("com.adobe.pdf", options: nil) { [unowned self] (result: NSSecureCoding?, error: NSError!) -> Void in
            if let data = result as? NSData {
                dispatch_async(dispatch_get_main_queue(),{
                    let pdfDoc = PDFDocument(data: data)
                    self.pdfView.setDocument(pdfDoc)
                })
            }
            
        }
        
        
        pdfView.setBackgroundColor(NSColor.clearColor())
        pdfView.setDisplayBox(kPDFDisplayBoxMediaBox)
        pdfView.setDisplaysPageBreaks(false)
        pdfView.setAutoScales(true)
        
        pdfThumbnailView.setBackgroundColor(NSColor.clearColor())
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

}
