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
class QObject;
class QString;
class ActionData;

#include "actions/iactionsdispatcher.h"
//#include "framework/actions/actiontypes.h"
#include "modularity/ioc.h"
#include "rcommand/icommanddispatcher.h"

namespace muse::ui {

class IOSEventTrampoline : public QObject, public kors::modularity::Contextable
{
public:
    
    static  IOSEventTrampoline* _Nonnull sharedTrampoline();
    
    muse::ContextInject<rcommand::ICommandDispatcher> commandDispatcher = { this };
    muse::ContextInject<muse::actions::IActionsDispatcher> dispatcher = { this };

    void setMetaKeyState(const QString& metaKeyName, bool state);

    void sendQKeyEvent(QKeyEvent* _Nonnull inEvent);
private:
    void dispatch(const std::string& command, const muse::actions::ActionData& args = muse::actions::ActionData());
    
    IOSEventTrampoline();
    
    static IOSEventTrampoline* _Nullable sSharedTrampoline;
};

}
#endif
#endif

