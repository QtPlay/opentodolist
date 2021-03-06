#ifndef ITEM_H
#define ITEM_H

#include <QDir>
#include <QLoggingCategory>
#include <QObject>
#include <QSharedPointer>
#include <QString>
#include <QUuid>
#include <QVariantMap>


/**
 * @brief Base class for all items in a library.
 *
 * This class is the base class for any kind of item which can either directly or indirectly
 * be stored in a Library. It provides the common interface any such item must have.
 */
class Item : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QUuid uid READ uid NOTIFY uidChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString displayTitle READ displayTitle NOTIFY titleChanged)
    Q_PROPERTY(QString itemType READ itemType CONSTANT)
    Q_PROPERTY(QString filename READ filename NOTIFY filenameChanged)
    Q_PROPERTY(double weight READ weight WRITE setWeight NOTIFY weightChanged)
    Q_PROPERTY(bool isValid READ isValid NOTIFY filenameChanged)

public:

    static const QString FileNameSuffix;

    explicit Item(QObject* parent = nullptr);
    explicit Item(const QString &filename,
                  QObject *parent = 0);
    explicit Item(const QDir &dir,
                  QObject *parent = 0);
    virtual ~Item();

    Q_INVOKABLE virtual bool deleteItem();
    Q_INVOKABLE bool load();
    Q_INVOKABLE bool save();
    Q_INVOKABLE QVariant toVariant() const;
    Q_INVOKABLE void fromVariant(QVariant data);


    /**
     * @brief Check if the item is valid.
     *
     * This returns true if the item is valid (i.e. it has a representation on disk). Otherwise,
     * returns false.
     */
    bool isValid() const { return !m_filename.isEmpty(); }

    /**
     * @brief The title of the item as shown in the user interface.
     */
    QString title() const { return m_title; }

    void setTitle(const QString &title);

    QString displayTitle() const;

    /**
     * @brief The file holding the item data.
     *
     * The filename property holds the name of the file containing the item's data
     * on disk.
     */
    QString filename() const { return m_filename; }

    /**
     * @brief The globally unique ID of the item.
     */
    QUuid uid() const { return m_uid; }
    void setUid(const QUuid &uid);

    QString itemType() const;

    double weight() const;
    void setWeight(double weight);

    QString directory() const;

    static Item *createItem(QVariantMap map, QObject *parent = nullptr);
    static Item *createItem(QVariant variant, QObject *parent = nullptr);
    static Item *createItem(QString itemType, QObject *parent = nullptr);
    static Item *createItemFromFile(QString filename, QObject *parent = nullptr);

public slots:

signals:

    void titleChanged();
    void uidChanged();
    void isValidChanged();
    void filenameChanged();
    void weightChanged();

    /**
     * @brief The item has been deleted.
     *
     * This signal is emitted when Item::deleteItem() is used to delete the item.
     */
    void itemDeleted(Item *item);

    /**
     * @brief The item has been reloaded.
     *
     * This signal is emitted to indicate that the item has been reloaded. This is
     * the case if the files on disk belonging to the item have changed.
     */
    void reloaded();

    /**
     * @brief Some properties of the item changed.
     */
    void changed();

protected:

    virtual QVariantMap toMap() const;
    virtual void fromMap(QVariantMap map);

private:

    QString     m_filename;
    QString     m_title;
    QUuid       m_uid;
    double      m_weight;
    bool        m_loading;

    void setFilename(const QString &filename);

    void setupChangedSignal();

};

typedef QSharedPointer<Item> ItemPtr;

Q_DECLARE_METATYPE(ItemPtr);

QDebug operator<<(QDebug debug, const Item *item);

Q_DECLARE_LOGGING_CATEGORY(item);

#endif // ITEM_H
