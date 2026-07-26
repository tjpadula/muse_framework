//
//  IOSPlatformPlugincpp.cpp
//  muse_ui
//
//  Created by Tom Padula on 7/23/26.
//

#include "iosplatformplugin.h"

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#include "log.h"

using namespace muse;
using namespace muse::ui;

void IOSPlatformPlugin::init()
{
    LOGD() << "IOSPlatformPlugin::init\n";
}

QString IOSPlatformPlugin::getPlatform()
{
    LOGD() << "IOSPlatformPlugin::getPlatform\n";
    return "ios";
}
