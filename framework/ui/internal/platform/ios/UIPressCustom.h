//
//  UIPressCustom.h
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPressCustom : UIPress

+ (instancetype) pressWithPhase:(UIPressPhase)inPhase window:(UIWindow*)inWindow responder:(UIResponder*)inResponder key:(UIKey*)inKey;

- (NSTimeInterval) timestamp;
- (UIPressPhase) phase; // UIPressPhaseBegan, Ended
- (UIPressType) type;

- (UIWindow*) window;
- (UIResponder*) responder;
- (NSArray <UIGestureRecognizer*>*) gestureRecognizers;

// For analog buttons, returns a value between 0 and 1.  Digital buttons return 0 or 1.
- (CGFloat) force;

/// For presses that originate from a hardware keyboard, contains a UIKey object describing the key being acted upon.
/// This property is nil if the press did not originate from a hardware keyboard.
- (UIKey*) key;

@end

NS_ASSUME_NONNULL_END
