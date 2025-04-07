import 'package:dataroutine6/core/database/local/database.dart';
import 'package:dataroutine6/core/database/local/interface/database_service.dart';

class DriftDatabaseService implements IDatabaseService {
  final AppDatabase _database;

  DriftDatabaseService(this._database);

  @override
  AppDatabase get database => _database;

  @override
  Future<void> close() => _database.close();
  
}
