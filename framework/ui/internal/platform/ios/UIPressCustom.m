//
//  UIPressCustom.m
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import "UIPressCustom.h"

@interface UIPressCustom()

- (instancetype) initWithPhase:(UIPressPhase)inPhase window:(UIWindow*)inWindow responder:(UIResponder*)inResponder key:(UIKey*)inKey;

@property NSTimeInterval _timestamp;
@property UIPressPhase _phase;
@property UIWindow* _window;
@property UIResponder* _responder;
@property UIKey* _key;

@end

@implementation UIPressCustom

+ (instancetype) pressWithPhase:(UIPressPhase)inPhase window:(UIWindow*)inWindow responder:(UIResponder*)inResponder key:(UIKey*)inKey
{
    return [[UIPressCustom alloc] initWithPhase:inPhase window:inWindow responder:inResponder key:inKey];
}

- (instancetype) initWithPhase:(UIPressPhase)inPhase window:(UIWindow*)inWindow responder:(UIResponder*)inResponder key:(UIKey*)inKey
{
    if (self = [super init]) {
        
        struct timespec anUptime;
        if (0 != clock_gettime(CLOCK_MONOTONIC_RAW, &anUptime)) {
            // Um, what do we do now?
        }
        self._timestamp = (int64_t)anUptime.tv_sec + (double)(anUptime.tv_nsec) / 1000000000;

        self._phase = inPhase;
        self._window = inWindow;
        self._responder = inResponder;
        self._key = inKey;
    }
    return self;
}

- (NSTimeInterval) timestamp
{
    return self._timestamp;
}

- (UIPressPhase) phase
{
    return self._phase;
}

- (UIPressType) type
{
    return 0;
}

- (UIWindow*) window
{
    return self._window;
}

- (UIResponder*) responder
{
    return self._responder;
}

- (NSArray <UIGestureRecognizer*>*) gestureRecognizers
{
    return NULL;
}

- (CGFloat) force
{
    return (self._phase == UIPressPhaseBegan) ? 1.0 : 0.0;
}

- (UIKey*) key
{
    return self._key;
}

@end
