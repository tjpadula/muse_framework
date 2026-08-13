//
//  IOSEventTrampoline.h
//  MuseScoreStudio
//
//  Created by Tom Padula on 7/27/26.
//

#ifdef __cplusplus

#ifndef IOSEventTrampoline_h
#define IOSEventTrampoline_h

class QKeyEvent;

namespace muse::ui {

class IOSEventTrampoline
{
public:
    static void sendQKeyEvent(QKeyEvent* _Nonnull inEvent);
};

}
#endif
#endif

