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
import TalkSchedule 1.0

Item {
    id: tweetModel
    property variant model: tweets
    property string bearerToken : ""
    property int status: XMLHttpRequest.UNSENT
    property bool isLoading: status === XMLHttpRequest.LOADING
    property bool wasLoading: false
    property string errorMessage: ""

    ListModel {
        id: tweets
    }

    function encodePhrase(x) { return encodeURIComponent(x); }
    signal isLoaded

    function reload() {
        tweets.clear()

        var req = new XMLHttpRequest;
        req.open("GET", "https://api.twitter.com/1.1/search/tweets.json?" +
                 "count=10&q=" + encodePhrase(applicationClient.currentConferenceDetails.TwitterTag) + "-filter:retweets");
        req.setRequestHeader("Authorization", "Bearer " + bearerToken);
        req.onreadystatechange = function() {
            status = req.readyState;
            if (status === XMLHttpRequest.DONE) {
                if (req.responseText !== "") { // Nothing was retrieved, network error
                    var objectArray = JSON.parse(req.responseText);
                    if (objectArray.errors !== undefined) {
                        console.log("Error fetching tweets: " + objectArray.errors[0].message)
                        errorMessage = objectArray.errors[0].message
                    } else {
                        for (var key in objectArray.statuses) {
                            var jsonObject = objectArray.statuses[key];
                            tweets.append(jsonObject);
                        }
                    }
                    if (wasLoading == true)
                        tweetModel.isLoaded()
                } else {
                    errorMessage = Theme.text.networkErrorInit
                }
            }
            wasLoading = (status === XMLHttpRequest.LOADING);
        }
        req.send();
    }

    Component.onCompleted: {
        var authReq = new XMLHttpRequest;
        authReq.open("POST", "https://api.twitter.com/oauth2/token");
        authReq.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        authReq.setRequestHeader("Authorization", "Basic " + Qt.btoa(consumerKey + ":" + consumerSecret));
        authReq.onreadystatechange = function() {
            if (authReq.readyState === XMLHttpRequest.DONE) {
                if (authReq.responseText !== "") { // Nothing was retrieved, network error
                    var jsonResponse = JSON.parse(authReq.responseText);
                    if (jsonResponse.errors !== undefined) {
                        console.log("Authentication error: " + jsonResponse.errors[0].message)
                        errorMessage = jsonResponse.errors[0].message
                    } else {
                        bearerToken = jsonResponse.access_token;
                        reload()
                    }
                } else {
                    errorMessage = Theme.text.networkErrorInit
                }
            }
        }
        authReq.send("grant_type=client_credentials");
    }
}
