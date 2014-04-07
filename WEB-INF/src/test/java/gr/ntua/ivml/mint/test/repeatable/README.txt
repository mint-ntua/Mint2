All tests in this package should run off the mint2Test.dmp.

Every test suit will check, if the test database exists and if so,
it will assume it is the authoritative non changed copy of it.


Tests may be run against its content. If the test wants to perform
changes to the database, the database must be restored at the end to
the original content!!

 