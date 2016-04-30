//
//  PrinterContainer.m
//  Esso
//
//  Created by Luke McGartland on 4/30/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

#import "PrinterContainer.h"
#import <Quartz/Quartz.h>

#define kMimeType @"application/pdf"

@implementation PrinterContainer

- (void)printPDF:(PDFDocument *)pdfDocument {
    [self printData:[pdfDocument dataRepresentation]];
}

- (void)printData:(NSData *)incomingPrintData {
    CFArrayRef printerList; //will soon be an array of PMPrinter objects
    PMServerCreatePrinterList(kPMServerLocal, &printerList);
    //
    
    //iterate over printerList and determine which one you want, assign to myPrinter
    PMPrinter myPrinter = (PMPrinter)CFArrayGetValueAtIndex(printerList, 0);
    
    PMPrintSession printSession;
    PMPrintSettings printSettings;
    PMCreateSession(&printSession);
    PMCreatePrintSettings(&printSettings);
    PMSessionDefaultPrintSettings(printSession, printSettings);
    
    CFArrayRef paperList;
    PMPrinterGetPaperList(myPrinter, &paperList);
    PMPaper usingPaper = (PMPaper)CFArrayGetValueAtIndex(paperList, 0);
    
    PMPageFormat pageFormat;
    PMCreatePageFormatWithPMPaper(&pageFormat, usingPaper);
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((CFDataRef)incomingPrintData);
    PMPrinterPrintWithProvider(myPrinter, printSettings, pageFormat, (CFStringRef)kMimeType, dataProvider);
    
    // Clean up
    
    CFRelease(printerList);
    
    PMRelease(printSession);
    PMRelease(printSettings);
    
    CFRelease(paperList);
    
    PMRelease(pageFormat);
    CGDataProviderRelease(dataProvider);
}


@end
