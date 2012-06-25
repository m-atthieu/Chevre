//
//  ChevreAppDelegate.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "BrowserViewController.h"

@interface ChevreAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet BrowserViewController* browserViewController;
@property (assign) IBOutlet NSArrayController* datesController;
@property (assign) IBOutlet NSArray* dates;

- (IBAction) openPreferencesWindow: (id) sender;
- (IBAction) openPreviewWindow: (id) sender;

@end
