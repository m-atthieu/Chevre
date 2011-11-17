#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface ImageBrowserView : IKImageBrowserView

@property NSUInteger treshold;
@property (retain) NSSet* initialTouches;
@property (retain) NSSet* currentTouches;
@end
