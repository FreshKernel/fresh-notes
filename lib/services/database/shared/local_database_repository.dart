import '../../../core/data/crud_repository.dart';
import '../../../core/services/s_app.dart';

abstract class LocalDatabaseRepository<O, I, I2, Id> extends AppService
    implements CrudRepository<O, I, I2, Id> {
  // Future<void> close();
}
