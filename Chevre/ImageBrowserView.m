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
    [self setZoomValue: [self zoomValue] + [event magnification]];
}

@end
