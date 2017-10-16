/**
 * This file is part of the source code and related artifacts for eGym Application.
 *
 * Copyright © 2013 eGym GmbH
 */
package dao;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.ReadPreference;
import domain.GuestbookEntry;
import org.joda.time.DateTime;
import org.mongojack.JacksonDBCollection;
import services.MongoDB;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.ThreadSafe;
import java.util.List;

@ThreadSafe
@Singleton
public class GuestbookEntryDao extends AbstractDao<GuestbookEntry> {

	private static final String COLLECTION_NAME = "guestbook-entry";

	private final JacksonDBCollection<GuestbookEntry, String> jacksonGuestbookEntryCollection;

	private final DBCollection guestBookEntryCollection;


	@Inject
	GuestbookEntryDao(final MongoDB mongoDB) {
		super(mongoDB.getDatabase(), mongoDB.getMongoClient());

		guestBookEntryCollection = getDb().getCollection(COLLECTION_NAME);

		guestBookEntryCollection.setReadPreference(ReadPreference.nearest());

		jacksonGuestbookEntryCollection = JacksonDBCollection.wrap(guestBookEntryCollection, GuestbookEntry.class, String.class);
	}

	@Override
	protected JacksonDBCollection<GuestbookEntry, String> getDbCollection() {
		return jacksonGuestbookEntryCollection;
	}

	@Override
	public void createIndexes() {
	}

	/**
	 * Updates the creation and update timestamps. The creation timestamp is only updated when then entity has no id. <br/>
	 * This method should be called only before the object is updated. If this method is called but the object is not updated, it can result
	 * in false data.
	 */
	private void updateTimestampsBeforeObjectUpdate(@Nullable final GuestbookEntry entity) {
		if (entity == null) {
			return;
		}
		final Long timestamp = Long.valueOf(DateTime.now().getMillis());
		if (entity.getTimestampCreation() == null) {
			entity.setTimestampCreation(timestamp);
		}
		entity.setTimestampUpdate(timestamp);
	}

	@Override
	public String save(@Nonnull final GuestbookEntry entity) {
		updateTimestampsBeforeObjectUpdate(entity);
		return super.save(entity);
	}

	@Nonnull
	public List<GuestbookEntry> findAllSortByTimestampCreation(final int limit) {
		return getDbCollection().find().sort(new BasicDBObject("timestampCreation", -1)).limit(limit).toArray();
	}
}
