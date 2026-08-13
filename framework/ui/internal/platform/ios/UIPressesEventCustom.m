//
//  UIPressesEventCustom.m
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import "UIPressesEventCustom.h"

@interface UIPressesEventCustom()

@property (nonatomic, readwrite, retain) NSSet<UIPress*>* _presses;

- (instancetype) initWithPresses:(NSSet <UIPress*>*)inPresses;

@end

@implementation UIPressesEventCustom

+ (instancetype) eventWithPresses:(NSSet <UIPress*>*)inPresses
{
    return [[UIPressesEventCustom alloc] initWithPresses:inPresses];
}

- (instancetype) initWithPresses:(NSSet <UIPress*>*)inPresses
{
    if (self = [super init]) {
        self._presses = [NSSet setWithSet:inPresses];
    }
    return self;
}

- (NSSet <UIPress *> *)allPresses
{
    return self._presses;
}

- (NSSet <UIPress *> *)pressesForGestureRecognizer:(UIGestureRecognizer *)gesture
{
    return NULL;
}

@end
