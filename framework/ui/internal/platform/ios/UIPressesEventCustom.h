//
//  UIPressesEventCustom.h
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPressesEventCustom : UIPressesEvent

+ (instancetype) eventWithPresses:(NSSet <UIPress*>*)inPresses;

- (NSSet <UIPress *> *)allPresses;
- (NSSet <UIPress *> *)pressesForGestureRecognizer:(UIGestureRecognizer *)gesture;

@end

NS_ASSUME_NONNULL_END
