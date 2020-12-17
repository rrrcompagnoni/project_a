users_attributes = ProjectA.produce_users_attributes(0, DateTime.now!("Etc/UTC"), 100)

:ok = ProjectA.bulk_insert_users(users_attributes)
