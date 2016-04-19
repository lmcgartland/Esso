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
    @IBOutlet weak var controlsView: NSView!
    @IBOutlet weak var pdfThumbnailView: CustomPDFThumbnailView!

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
        f.size.width = 800;
        f.size.height = 600;
        self.view.frame = f;
        
        
        
        // Do any additional setup after loading the view.
        let myExtensionContext = self.extensionContext
        /*if let items = myExtensionContext?.inputItems {
            /*for obj in items {
                //print("Object: \(obj.attributedTitle)")
            }*/
        }*/
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
        
        controlsView.layer?.backgroundColor = NSColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        pdfView.setBackgroundColor(NSColor.clearColor())
        pdfView.setDisplayBox(kPDFDisplayBoxMediaBox)
        pdfView.setDisplaysPageBreaks(false)
        pdfView.setAutoScales(true)
        
        //pdfThumbnailView.layer?.backgroundColor = NSColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.1).CGColor
        
        /*for subview in pdfThumbnailView.subviews {
            // Manipulate the view
            let caLayer = CALayer()
            caLayer.backgroundColor = NSColor.clearColor().CGColor
            subview.layer = caLayer
            /*for subview2 in subview.subviews {
                // Manipulate the view
                
                subview2.layer = caLayer
                
            }*/
        }*/
        
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
