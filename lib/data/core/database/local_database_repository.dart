import '../../../core/services/s_app.dart';
import '../crud_repository.dart';

abstract class LocalDatabaseRepository<Output, CreateInput, UpdateInput,
        EntityId> extends AppService
    implements CrudRepository<Output, CreateInput, UpdateInput, EntityId> {
  // Future<void> close();
}
