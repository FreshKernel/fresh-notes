import 'package:my_notes/core/data/crud_repository.dart';

abstract class CloudDatabaseRepository<O, I, I2, Id>
    extends CrudRepository<O, I, I2, Id> {}
