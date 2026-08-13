//
//  UIKeyModifiersOnly.m
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import "UIKeyModifiersOnly.h"

@interface UIKeyModifiersOnly()

- (instancetype) initWithModifiers:(UIKeyModifierFlags)inModifiers andKeyCode:(UIKeyboardHIDUsage)inKeyCode;

@end

@implementation UIKeyModifiersOnly

+ (instancetype) newObjectWithModifiers:(UIKeyModifierFlags)inModifiers andKeyCode:(UIKeyboardHIDUsage)inKeyCode
{
    return [[UIKeyModifiersOnly alloc] initWithModifiers:inModifiers andKeyCode:inKeyCode];
}

- (instancetype) initWithModifiers:(UIKeyModifierFlags)inModifiers andKeyCode:(UIKeyboardHIDUsage)inKeyCode
{
    if (self = [super init]) {
        self._modifiers = inModifiers;
        self._keyCode = inKeyCode;
    }
    return self;
}

- (NSString *) characters
{
    return [NSString new];
}

- (NSString *) charactersIgnoringModifiers
{
    return [NSString new];
}

- (UIKeyModifierFlags) modifierFlags
{
    return self._modifiers;
}

- (UIKeyboardHIDUsage) keyCode
{
    return self._keyCode;
}

@end
