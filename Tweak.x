#import <UIKit/UIKit.h>

@interface NJIsland : UIView
+ (id)sharedInstance;
- (void)collapse;
- (void)setExpanded:(BOOL)expanded;
@end

@interface SBRecordingIndicatorWindow : UIWindow
@end

static float xPos = 187.0;
static float yPos = 57.0;
static BOOL enabled = YES;

static void loadPrefs() {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.tech.pilldotsfix"];
    if ([defaults objectForKey:@"xPos"]) xPos = [defaults floatForKey:@"xPos"];
    if ([defaults objectForKey:@"yPos"]) yPos = [defaults floatForKey:@"yPos"];
    if ([defaults objectForKey:@"enabled"]) enabled = [defaults boolForKey:@"enabled"];
}

%hook SBRecordingIndicatorWindow
- (void)layoutSubviews {
    %orig;
    if (enabled) {
        self.frame = CGRectMake(xPos, yPos, 15, 15);
        self.layer.zPosition = 9999;
    }
}
%end

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)application {
    %orig;
    NSLog(@"[PillDotsFix] SpringBoard launched, registering observers");

    [[NSNotificationCenter defaultCenter] addObserverForName:@"SBApplicationActivatedNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
        NSLog(@"[PillDotsFix] App activated notification fired");

        Class islandClass = %c(NJIsland);
        if (islandClass) {
            id island = [islandClass sharedInstance];
            if (island) {
                NSLog(@"[PillDotsFix] calling collapse on island %@", island);
                [island collapse];
            } else {
                NSLog(@"[PillDotsFix] island sharedInstance is nil");
            }
        } else {
            NSLog(@"[PillDotsFix] NJIsland class not found");
        }
    }];
}
%end

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.tech.pilldotsfix/prefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}