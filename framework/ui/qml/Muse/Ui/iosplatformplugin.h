//
//  IOSPlatformPlugin.h
//  muse_ui
//
//  Created by Tom Padula on 7/23/26.
//

#pragma once

#include <stdio.h>

#include <qqmlintegration.h>
#include <QtCore/qtsymbolmacros.h>
#include <QtQml/qqmlextensionplugin.h>

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#include "log.h"

// Don't try to use this yet. Even though it seems to get built and
// included in the qml part of the build, it's not accessible from
// qml at all. Doing so will cause a crash on launch with QML
// complaining that IOSPlatformPlugin is an unknown type.

namespace muse::ui {
class IOSPlatformPlugin : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_ELEMENT

public:
    explicit IOSPlatformPlugin(QObject* parent = nullptr) :
        QObject(parent)
    {
        LOGD() << "IOSPlatformPlugin::IOSPlatformPlugin\n";
    }

    Q_INVOKABLE void init();
    Q_INVOKABLE QString getPlatform();
};
}
