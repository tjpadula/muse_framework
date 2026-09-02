/*
 * SPDX-License-Identifier: GPL-3.0-only
 * MuseScore-CLA-applies
 *
 * MuseScore Studio
 * Music Composition & Notation
 *
 * Copyright (C) 2026 MuseScore Limited and others
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#include "applicationeventcontroller.h"

#ifndef NO_QT_SUPPORT

#include <QCoreApplication>

#include "containers.h"
#include "runtime.h"

#include "log.h"

using namespace muse;

ApplicationEventController::ApplicationEventController()
{
    DO_ASSERT(std::this_thread::get_id() == runtime::mainThreadId());
    qApp->installEventFilter(this);
}

ApplicationEventController::~ApplicationEventController()
{
    if (qApp) {
        qApp->removeEventFilter(this);
    }
}

async::Channel<IApplicationEventController::EventData> ApplicationEventController::eventReceived() const
{
    return m_eventReceived;
}

void ApplicationEventController::setPendingEventTypes(const std::vector<QEvent::Type>& types)
{
    m_pendingTypes = types;
}

std::vector< std::unique_ptr<QEvent> > ApplicationEventController::takePendingEvents()
{
    DO_ASSERT(std::this_thread::get_id() == runtime::mainThreadId());

    m_pendingTypes.clear();
    std::vector<std::unique_ptr<QEvent> > events = std::move(m_pendingEvents);
    m_pendingEvents.clear();

    return events;
}

// Let's see if this works, if so it should be in a utilities file someplace instead. This should
// apply for any EnumType:
template<typename EnumType>
QString ToString(const EnumType& enumValue)
{
    const char* enumName = qt_getEnumName(enumValue);
    const QMetaObject* metaObject = qt_getEnumMetaObject(enumValue);
    if (metaObject)
    {
        const int enumIndex = metaObject->indexOfEnumerator(enumName);
        return QString("%1::%2::%3").arg(metaObject->className(), enumName, metaObject->enumerator(enumIndex).valueToKey(enumValue));
    }
    
    return QString("%1::%2").arg(enumName).arg(static_cast<int>(enumValue));
}

bool ApplicationEventController::eventFilter(QObject* watched, QEvent* event)
{
#if 1
    
    // This might work.
    if ((event->type() != QEvent::Type::Timer) &&       // We get a lot of these, at least one per second.
        (event->type() != QEvent::Type::SockAct)) {     // This can start screaming.
        std::stringstream aStream;
        // I find it hard to believe that QString does not have at least an output stream operator,
        // but it doesn't.
        std::string anEventTypeString = (ToString(event->type())).toStdString();
        if (anEventTypeString.compare("QEvent::Type::") == 0) {
            aStream << __PRETTY_FUNCTION__ << " unknown event enum: " << event->type();
            aStream << std::endl;
            fprintf (stderr, "%s", aStream.str().c_str());
        } else {
            //            aStream << __PRETTY_FUNCTION__ << " incoming event: " << anEventTypeString;
            if ((event->type() == QEvent::Type::KeyPress) || (event->type() == QEvent::Type::KeyRelease)) {
                aStream << __PRETTY_FUNCTION__ << " incoming event: " << anEventTypeString;
                QKeyEvent* aKeyEvent = dynamic_cast<QKeyEvent*>(event);
                if (aKeyEvent && (!aKeyEvent->isAutoRepeat())) {
                    int aLatin1Char = -1;
                    if (aKeyEvent->text().length() > 0) {
                        QChar aSingleChar = aKeyEvent->text().front();
                        aLatin1Char = aSingleChar.toLatin1();
                    }
                    aStream << ", text: " << aKeyEvent->text()
                        .toStdString() << " == " << aLatin1Char << ", key: 0x" <<  std::hex << aKeyEvent->key() << std::dec << ", native virtual key: " << aKeyEvent->nativeVirtualKey() << ", native scan code: " << aKeyEvent->nativeScanCode() << ", native modifiers: " << aKeyEvent->nativeModifiers() << ", mods: ";
                    if (aKeyEvent->modifiers() &  Qt::ShiftModifier) {
                        aStream << "Shift ";
                    }
                    if (aKeyEvent->modifiers() &  Qt::ControlModifier) {
                        aStream << "Control ";
                    }
                    if (aKeyEvent->modifiers() &  Qt::AltModifier) {
                        aStream << "Option ";
                    }
                    if (aKeyEvent->modifiers() &  Qt::MetaModifier) {
                        aStream << "Command ";
                    }
                    if (aKeyEvent->modifiers() &  Qt::KeypadModifier) {     // arrows need this
                        aStream << "Keypad ";
                    }
                    aStream << "watched: " << watched->objectName().toStdString();
                }
                aStream << std::endl;
                fprintf (stderr, "%s", aStream.str().c_str());
            }
        }
    }
    
#endif
    if (contains(m_pendingTypes, event->type())) {
        m_pendingEvents.emplace_back(event->clone());
    }

    m_eventReceived.send(EventData { watched, event });
    return false;
}

#endif // NO_QT_SUPPORT
