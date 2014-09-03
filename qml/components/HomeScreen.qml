/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.XmlListModel 2.0
import TalkSchedule 1.0

Rectangle {
    id: homeScreenWindow
    height: window.height - header.height
    width: window.width
    property int trackHeight: 150

    Column {
        spacing: 2

        Rectangle {
            // upcoming
            // Todo: List upcoming talks
            width: homeScreenWindow.width
            height: homeScreenWindow.height / 3

            Text {
                id: labelUpcoming
                text: Theme.text.upcoming
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.AllUppercase
            }
            ListView {
                id: homeScreenListView
                anchors.top: labelUpcoming.bottom
                anchors.margins: 10
                model: ModelsSingleton.eventModel
                delegate: Text {
                    text: "Topic: " + topic
                }
            }
        }
        Rectangle {
            // news
            width: window.width
            height:  window.height / 3

            XmlListModel {
                id: rssXmlModel
                source: "http://feeds.feedburner.com/QtDD14-EUROPE"
                query: "/rss/channel/item"

                XmlRole { name: "title"; query: "title/string()" }
                XmlRole { name: "description"; query: "description/string()" }
            }

            Text {
                id: labelNews
                text: Theme.text.news
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.AllUppercase
            }
            ListView {
                anchors.top: labelNews.bottom
                model: rssXmlModel
                delegate: Text {
                    x: 10
                    width: window.width - 20
                    text: "<b>" + title + "</b>" + "\n" + description
                    textFormat: Text.StyledText
                    wrapMode: Text.Wrap
                }
            }
        }
        Rectangle {
            // useful info
            // Todo: Content
            width: window.width
            height:  window.height / 3
            Text {
                id: labelInfo
                text: Theme.text.info
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.capitalization: Font.AllUppercase
            }
            Text {
                anchors.top: labelInfo.bottom
                text: "Lorem Ipsum"
            }
        }
    }
}
