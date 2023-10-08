import '../../../../core/services/s_app.dart';
import '../../shared/database_operation_repository.dart';

abstract class LocalDatabaseRepository<Output, CreateInput, UpdateInput,
        EntityId> extends AppService
    implements
        DatabaseOperationRepository<Output, CreateInput, UpdateInput,
            EntityId> {}
