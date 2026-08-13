//
//  IOSEventTrampoline.mm
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/27/26.
//

#import "IOSEventTrampoline.h"

#import "UIKeyCustom.h"
#import "UIKeyModifiersOnly.h"
#import "UIPressesEventCustom.h"
#import "UIPressCustom.h"

#ifdef __cplusplus
#include <QKeyEvent>
#include <QtCore/qnamespace.h>
#include "log.h"
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOSEventTrampoline_objc : NSObject

+ (void) sendEvent:(UIEvent*)inEvent;

@end

NS_ASSUME_NONNULL_END

UIWindow* keyQUIWindow ();

UIWindow* keyUIWindow (void) {
    static UIWindow* sUIWindow = nil;
    if (sUIWindow == nil) {
        
        // Just grab the first key window, there should be only one anyway.
        NSSet* aSceneSet = [[UIApplication sharedApplication] connectedScenes];
        LOGI() << "Total num of scenes: " << aSceneSet.count << "\n";
        int aSceneCount = 0;
        for (UIScene* aScene in aSceneSet) {
            if ([aScene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene* aWindowScene = (UIWindowScene*)aScene;
                LOGI() << "Total num of windows in windowScene " << aSceneCount++ << ": " << aWindowScene.windows.count << "\n";
                sUIWindow = [aWindowScene keyWindow];
                LOGI() << "Found key window: " << [sUIWindow.description cStringUsingEncoding:NSUTF8StringEncoding] << "\n";
                break;
            }
        }
    }
    return sUIWindow;
}

// We have this ifdef because Xcode 26.3 can't remember whether this file is Obj-C++ or Obj-C.
// The build system does the right thing, but the syntax checker thinks this file is plain
// Objective-C and flags all the C++ as errors.

#ifdef __cplusplus
using namespace muse::ui;
using namespace Qt;

void IOSEventTrampoline::sendQKeyEvent(QKeyEvent* _Nonnull inKeyEvent)
{
    // Convert the QKeyEvent into a UIEventCustom and send it along. The
    // QKeyEvent may be a meta key or it could be a character key.
    
    // And yes, generating the meta keys with strings in QML only to
    // convert them to Qt::KeyboardModifiers in C++ then converting
    // those to UIKeyModifierFlags is a bit tedious, but it's a clean
    // way of keeping the three worlds (QML, C++, Obj-C) separate.
    
    UIKeyModifierFlags aModifierFlags = 0;
    UIKeyboardHIDUsage aKeyCode = (UIKeyboardHIDUsage)0;
    if (inKeyEvent->modifiers() & Qt::ShiftModifier) {
        aModifierFlags |= UIKeyModifierShift;
        aKeyCode = UIKeyboardHIDUsageKeyboardLeftShift;
    }
    if (inKeyEvent->modifiers() & Qt::ControlModifier) {
        aModifierFlags |= UIKeyModifierControl;
        aKeyCode = UIKeyboardHIDUsageKeyboardLeftControl;
    }
    if (inKeyEvent->modifiers() & Qt::AltModifier) {
        aModifierFlags |= UIKeyModifierAlternate;           // C'mon, Apple, be consistent: Here they call it 'Alternate'...
        aKeyCode = UIKeyboardHIDUsageKeyboardLeftAlt;       // ...but here they call it 'Alt'.
    }
    if (inKeyEvent->modifiers() & Qt::MetaModifier) {
        aModifierFlags |= UIKeyModifierCommand;
        aKeyCode = UIKeyboardHIDUsageKeyboardLeftGUI;       // And who knows why 'Command' is 'GUI'.
    }
    
    if (inKeyEvent->key() == Qt::Key_Backspace) {
        aKeyCode = UIKeyboardHIDUsageKeyboardDeleteOrBackspace;
    }
    if (inKeyEvent->key() == Qt::Key_Escape) {
        aKeyCode = UIKeyboardHIDUsageKeyboardEscape;
    }
    
    if (aModifierFlags == 0) {
        // The key wasn't a meta key of some sort. Send it along as a normal key.
        NSString* aChars = [NSString stringWithCString:inKeyEvent->text().toStdString().c_str() encoding:NSUTF8StringEncoding];
        int aRawUTFValue = inKeyEvent->key();
        QString aRawString = QString::fromUtf16((char16_t*)(&aRawUTFValue), 1);
        NSString* aCIM = [NSString stringWithCString:aRawString.toStdString().c_str() encoding:NSUTF16StringEncoding];
//        aKeyCode =
        // Someday we need to map in reverse from the given key to a Mac keyboard key code (in UIKeyConstants.h).
        // People usually want to go the other way around, so there isn't a ready implementation of that
        // functionality. If we do want to send character keys along, we will probably need to finish this.
        UIKeyCustom* aUIKey = [UIKeyCustom keyWithCharacters:aChars
                                 charactersIgnoringModifiers:aCIM
                                               modifierFlags:aModifierFlags
                                                     keyCode:aKeyCode];
        UIPressPhase aPhase = (inKeyEvent->type() == QActionEvent::KeyPress) ? UIPressPhaseBegan : UIPressPhaseEnded;
        UIPressCustom* aPress = [UIPressCustom pressWithPhase:aPhase
                                                       window:keyUIWindow()
                                                    responder:keyUIWindow()
                                                          key:aUIKey];
        UIPressesEventCustom* anEvent = [UIPressesEventCustom eventWithPresses:[NSSet<UIPress*> setWithObject:aPress]];
        [IOSEventTrampoline_objc sendEvent:anEvent];
    }
    
    // Make sure we found something we recognize.
    if (aKeyCode != 0) {
        UIKeyModifiersOnly* aUIKey = [UIKeyModifiersOnly newObjectWithModifiers:aModifierFlags andKeyCode:aKeyCode];
        
        UIPressPhase aPhase = (inKeyEvent->type() == QActionEvent::KeyPress) ? UIPressPhaseBegan : UIPressPhaseEnded;
        UIPressCustom* aPress = [UIPressCustom pressWithPhase:aPhase
                                                       window:keyUIWindow()
                                                    responder:keyUIWindow()
                                                          key:aUIKey];
        UIPressesEventCustom* anEvent = [UIPressesEventCustom eventWithPresses:[NSSet<UIPress*> setWithObject:aPress]];
        [IOSEventTrampoline_objc sendEvent:anEvent];
    }
}
#endif

@implementation IOSEventTrampoline_objc

+ (void) sendEvent:(UIEvent*)inEvent
{
    LOGI() << "[IOSEventTrampoline_objc sendEvent:] event: " << [inEvent.description cStringUsingEncoding:NSUTF8StringEncoding] << "\n";
//    [keyUIWindow() sendEvent:inEvent];
    [[UIApplication sharedApplication] sendEvent:inEvent];
}

@end
