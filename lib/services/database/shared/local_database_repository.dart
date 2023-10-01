import 'package:my_notes/core/data/crud_repository.dart';
import 'package:my_notes/core/services/s_app.dart';

abstract class LocalDatabaseRepository<O, I, I2, Id> extends AppService
    implements CrudRepository<O, I, I2, Id> {
  // Future<void> close();
}
