import '../../shared/database_operation_repository.dart';

abstract class CloudDatabaseRepository<Output, CreateInput, UpdateInput,
        EntityId>
    extends DatabaseOperationRepository<Output, CreateInput, UpdateInput,
        EntityId> {}
