//
//  PrinterContainer.h
//  Esso
//
//  Created by Luke McGartland on 4/30/16.
//  Copyright © 2016 Luke McGartland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface PrinterContainer : NSObject
- (void)printPDF:(PDFDocument *)pdfDocument;
@end
