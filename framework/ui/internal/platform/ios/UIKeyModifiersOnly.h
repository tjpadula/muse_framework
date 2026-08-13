//
//  UIKeyModifiersOnly.h
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/29/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIKeyModifiersOnly : UIKey

@property (nonatomic, readwrite) UIKeyModifierFlags _modifiers;
@property (nonatomic, readwrite) UIKeyboardHIDUsage _keyCode;

+ (instancetype) newObjectWithModifiers:(UIKeyModifierFlags)inModifiers andKeyCode:(UIKeyboardHIDUsage)inKeyCode;

- (NSString *) characters;
- (NSString *) charactersIgnoringModifiers;
- (UIKeyModifierFlags) modifierFlags;
- (UIKeyboardHIDUsage) keyCode;

@end

NS_ASSUME_NONNULL_END
