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

@property (retain) Datasource* datasource;

@property (assign) IBOutlet IKImageBrowserView* browserView;
@property (assign) IBOutlet NSPopUpButton* directoryPopup;
@property (assign) IBOutlet NSSlider* slider;

/* HUDWindow */
@property (assign) IBOutlet NSPanel* panel;
@property (assign) IBOutlet NSTextField* nameTextField;
@property (assign) IBOutlet NSPopUpButton* categoryPopup;

@property (assign) NSUndoManager* undoManager;

/*!
 * callback for grouping selection, called by menu item, display HUD panel
 */
- (IBAction) groupSelection: (id) sender;
/*!
 * callback for creating a group, called by HUD panel
 */
- (IBAction) createGroup: (id) sender;
/*!
 * callback when cancelling creating a group, called by HUD panel
 */
- (IBAction) cancelCreateGroup: (id) sender;
/*!
 * update the size of the thumbnails
 */
- (IBAction) updateSize: (id) sender;
/*!
 * callback when removing images in selection from respective groups
 */
- (IBAction) ungroupSelection: (id) sender;
/*!
 * callback for deleting group under selection
 */
- (IBAction) deleteGroupAtSelection: (id)sender;
/*!
 * callback for editing 
 */
- (IBAction) editGroupAtSelection: (id) sender;
/*!
 *
 */
- (IBAction) addSelectionToGroup: (id) sender;


/*!
 * empties the HUD panel from previous data, making it clean
 */
- (void) emptyPanel;
/*!
 * this method updates the datasource and then the IKImageBrowserView 
 */
- (void) updateDatasource: (Datasource*) aDatasource;

@end
