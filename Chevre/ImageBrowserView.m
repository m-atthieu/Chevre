#import "ImageBrowserView.h"

@implementation ImageBrowserView

@synthesize treshold;
@synthesize initialTouches;
@synthesize currentTouches;

- (void) awakeFromNib
{
    [self setAcceptsTouchEvents: YES];
    [self setTreshold: 6];
}

- (void) magnifyWithEvent:(NSEvent *) event
{
    //NSLog(@"zooming");
    [self setZoomValue: [self zoomValue] + [event magnification]];
    //[self setNeedsDisplay: YES];
}

@end
