# ActiveRecord Lite

## What is it?

ActiveRecord Lite is a clone of ActiveRecord, Rails’ implementation of the [active record pattern](https://en.wikipedia.org/wiki/Active_record_pattern). It implements inserting and updating records, generates attributes from columns in the database, and supports the creation of associations between models.

## Usage

Models should subclass SQLObject, and database connections are made using the DBConnection singleton.
