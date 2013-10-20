/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2013  Martin Höher <martin@rpdev.net>
 * 
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef LOCALXMLTODO_H
#define LOCALXMLTODO_H

#include <abstracttodo.h>


class LocalXmlTodo : public AbstractTodo
{

    Q_OBJECT
    
public:
    
    explicit LocalXmlTodo( QUuid id, const QString& configFile, AbstractTodoList* parent = 0);
    virtual ~LocalXmlTodo();
    
private:
    
    QString m_configFile;
    QUuid m_parentId;
    QString m_parentConfigFile;
    
private slots:
    
    void save();
    void load();
    
    void updateParentTodo();
    
};

#endif // LOCALXMLTODO_H
