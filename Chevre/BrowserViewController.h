//
//  BrowserView.h
//  Chevre
//
//  Created by Matthieu DESILE on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

#import "Datasource.h"

@interface BrowserViewController : NSObject

@property (assign) IBOutlet IKImageBrowserView* browserView;
@property (retain) Datasource* datasource;
@property (assign) IBOutlet NSPopUpButton* directoryPopup;
@property (assign) IBOutlet NSSlider* slider;

/* HUDWindow */
@property (assign) IBOutlet NSPanel* panel;
@property (assign) IBOutlet NSTextField* nameTextField;
@property (assign) IBOutlet NSPopUpButton* categoryPopup;

- (void) groupSelection;
- (IBAction) createGroup: (id) sender;
- (IBAction) cancelCreateGroup: (id) sender;
- (void) emptyPanel;
- (IBAction) updateSize: (id) sender;
- (void) updateDatasource: (Datasource*) aDatasource;

@end
