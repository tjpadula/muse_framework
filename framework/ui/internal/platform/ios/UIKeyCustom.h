//
//  UIKeyCustom.h
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIKeyCustom : UIKey

+ (instancetype) keyWithCharacters:(NSString*)inCharacters
       charactersIgnoringModifiers:(NSString*)inCIM
                     modifierFlags:(UIKeyModifierFlags)inFlags
                           keyCode:(UIKeyboardHIDUsage)inKeyCode;

/// @returns a string representing what would be inserted into a text field when this key is pressed.
/// @discussion if a modifier key is held, this property will contain the modified characters according
/// the rules for that particular modifier key (i.e., if shift is held on a Latin keyboard, this will
/// contain capital letters).
- (NSString*) characters;

/// @returns a string representing which characters would be inserted into a text field when this key is
/// pressed, not taking any held modifiers into account.
/// @discussion for Latin based languages, expect this to be always in lowercase (unmodified meaning not
/// taking shift key into account). If only a modifier key was pressed, this property will contain an empty string.
- (NSString*) charactersIgnoringModifiers;

/// @returns a bitfield representing which modifier keys are currently being held in addition to this key.
- (UIKeyModifierFlags) modifierFlags;

/// @returns the raw HID usage code for the pressed key. See UIKeyConstants.h.
- (UIKeyboardHIDUsage) keyCode;

@end

NS_ASSUME_NONNULL_END
