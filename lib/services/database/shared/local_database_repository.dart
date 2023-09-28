import 'package:my_notes/core/data/crud_repository.dart';
import 'package:my_notes/core/services/service.dart';

abstract class LocalDatabaseRepository<O, I, Id> extends AppService
    implements CrudRepository<O, I, Id> {
  Future<void> close();
}
