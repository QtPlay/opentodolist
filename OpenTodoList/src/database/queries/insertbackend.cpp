/*
 *  OpenTodoList - A todo and task manager
 *  Copyright (C) 2014 - 2015 Martin Höher <martin@rpdev.net>
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

#include "insertbackend.h"

namespace OpenTodoList {
namespace DataBase {
namespace Queries {

/**
   @brief Constructor

   This will create a new InsertBackend query. The query object can be used to
   insert the @p backend into the database if it does not exist. Otherwise, it will
   update an existing instance (using the Backend::name() to determine whether the
   object already exists in the database).

   @note The query takes over ownership of the backend.
 */
InsertBackend::InsertBackend( Backend *backend ) :
  OpenTodoList::DataBase::StorageQuery(),
  m_backend( backend ),
  m_state( InsertBackendState ),
  m_waitForId( false )
{
  Q_ASSERT( backend != nullptr );
}

/**
   @brief Destructor
 */
InsertBackend::~InsertBackend()
{
  delete m_backend;
}

bool InsertBackend::query(QString &query, QVariantMap &args, int &options)
{
  m_waitForId = false;
  switch ( m_state ) {
  case InsertBackendState:
  {
    options = StorageQuery::QueryIsUpdateQuery;
    query = "INSERT OR REPLACE INTO backend ( id, name, title, description ) "
            "VALUES ( (SELECT id FROM backend WHERE name = :searchName ), :name, :title, :description );";
    args.insert( "searchName", m_backend->name() );
    args.insert( "name", m_backend->name() );
    args.insert( "title", m_backend->title() );
    args.insert( "description", m_backend->description() );
    m_state = RemoveCapabilitiesState;
    m_waitForId = true;
    return true;
  }

  case RemoveCapabilitiesState:
  {
    query = "DELETE FROM backendCapability WHERE backend = ("
            "SELECT id FROM backend WHERE name = :name);";
    args.insert( "name", m_backend->name() );
    if ( m_backend->capabilities().isEmpty() ) {
      m_state = FinishedState;
    } else {
      m_state = InsertCapabilitiesState;
    }
    return true;
  }

  case InsertCapabilitiesState:
  {
    query = "WITH backendInfo (id) AS ( SELECT id FROM backend WHERE name = :name ) "
            "INSERT INTO backendCapability ( backend, capability ) "
            "VALUES ";
    args.insert( "name", m_backend->name() );
    QStringList caps;
    int i = 0;
    for ( Backend::Capabilities cap : m_backend->capabilities() ) {
      QString capName = QString( "capability%1" ).arg( ++i );
      caps << QString("( (SELECT id FROM backendInfo), :%1)").arg( capName );
      args.insert( capName, QVariant::fromValue<int>( cap ) );
    }
    query += caps.join( ", ") + ";";
    m_state = FinishedState;
    return true;
  }

  default:
    return false;
  }


}

void InsertBackend::newIdAvailable(const QVariant &id)
{
  if ( m_waitForId && id.isValid() ) {
    m_backend->setId( id.toInt() );
  }
}

void InsertBackend::endRun()
{
  emit backendChanged( m_backend->toVariant() );
}

bool InsertBackend::hasNext() const
{
  return m_state != FinishedState;
}

} // namespace Queries
} // namespace DataBase
} // namespace OpenTodoList
