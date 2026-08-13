//
//  UIKeyCustom.m
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import "UIKeyCustom.h"

@interface UIKeyCustom ()

@property NSString* _characters;
@property NSString* _CIM;
@property UIKeyModifierFlags _modifierFlags;
@property UIKeyboardHIDUsage _keyCode;

- (instancetype) initWithCharacters:(NSString*)inCharacters
        charactersIgnoringModifiers:(NSString*)inCIM
                      modifierFlags:(UIKeyModifierFlags)inFlags
                            keyCode:(UIKeyboardHIDUsage)inKeyCode;

@end

@implementation UIKeyCustom

+ (instancetype) keyWithCharacters:(NSString*)inCharacters
       charactersIgnoringModifiers:(NSString*)inCIM
                     modifierFlags:(UIKeyModifierFlags)inFlags
                           keyCode:(UIKeyboardHIDUsage)inKeyCode
{
    return [[UIKeyCustom alloc] initWithCharacters:inCharacters
                       charactersIgnoringModifiers:inCIM
                                     modifierFlags:inFlags
                                           keyCode:inKeyCode];
}

- (instancetype) initWithCharacters:(NSString*)inCharacters
        charactersIgnoringModifiers:(NSString*)inCIM
                      modifierFlags:(UIKeyModifierFlags)inFlags
                            keyCode:(UIKeyboardHIDUsage)inKeyCode
{
    if (self = [super init]) {
        self._characters = inCharacters;
        self._CIM = inCIM;
        self._modifierFlags = inFlags;
        self._keyCode = inKeyCode;
    }
    return self;
}

- (NSString*) characters
{
    return self._characters;
}

- (NSString*) charactersIgnoringModifiers
{
    return self._CIM;
}

- (UIKeyModifierFlags) modifierFlags
{
    return self._modifierFlags;
}

- (UIKeyboardHIDUsage) keyCode
{
    return self._keyCode;
}

@end
