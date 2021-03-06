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

#ifndef MODEL_H
#define MODEL_H

#include <QtCore/QAbstractListModel>
#include <QtCore/QMap>
#include <QtCore/QList>
#include <QtQml/QJSValue>
#include <QtCore/QJsonObject>

class EnginioReply;

class Model : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QString conferenceId READ conferenceId WRITE setConferenceId NOTIFY conferenceIdChanged)
    Q_PROPERTY(QString fileNameTag READ fileNameTag WRITE setFileNameTag NOTIFY fileNameTagChanged)

public:
    explicit Model(QObject *parent = 0);

    // from QAbstractItemModel

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    QString conferenceId() const { return m_conferenceId; }
    void setConferenceId(const QString &id);
    QString fileNameTag() const { return m_fileNameTag; }
    void setFileNameTag(const QString &newTag);

    Q_INVOKABLE int rowCount(const QModelIndex &parent = QModelIndex()) const;
    Q_INVOKABLE QVariant data(int index, const QString &role) const;
    Q_INVOKABLE void addFavorite(const QString &data);
    Q_INVOKABLE void removeFavorite(const QString &data);
    Q_INVOKABLE void addRow(const QJsonObject &data);
    Q_INVOKABLE void removeRow(int index);
    Q_INVOKABLE QVariant indexOf(const QString &role, QVariant value);

    Q_INVOKABLE bool load();
    Q_INVOKABLE bool appendAndSaveFavorites(const QString &data, bool isAdded);
    Q_INVOKABLE void reset();

Q_SIGNALS:
    void clientChanged();
    void conferenceIdChanged();
    void fileNameTagChanged();
    void dataReady();

public Q_SLOTS:
    void onFinished(EnginioReply *reply);

private:
    bool save(const QJsonObject &object);
    bool parse(const QJsonObject &object);

    QHash<int, QByteArray> m_roleNames;
    QList<QMap<QString, QVariant> > m_data;
    QMap<QString, QJsonObject> currentModelObject;
    QString m_conferenceId;
    QString m_fileNameTag;
};

#endif // MODEL_H
