import 'package:flutter/foundation.dart' show immutable;
import 'package:my_notes/core/log/logger.dart';

@immutable
abstract class SyncOptions {
  const SyncOptions();

  bool get isSyncWithCloud;
  String? get cloudId;

  static NoSyncOption noSync() {
    return const NoSyncOption._();
  }

  static SyncWithCloudOption syncWithCloud() {
    return const SyncWithCloudOption._();
  }

  static SyncWithExistingCloudIdOption syncWithExistingCloudId(String cloudId) {
    return SyncWithExistingCloudIdOption._(cloudId);
  }

  bool get isExistsInCloud {
    final option = this;
    if (option is SyncWithExistingCloudIdOption) {
      return true;
    }
    if (option is SyncWithCloudOption) {
      AppLogger.log(
        'Note does not exists yet but we want to create it so it will by synced.',
      );
      return false;
    }

    /// It does not exists and probabtly the it has no sync
    return false;
  }

  factory SyncOptions.getSyncOptions({
    required bool isSyncWithCloud,
    required String? existingCloudNoteId,
  }) {
    if (isSyncWithCloud) {
      if (existingCloudNoteId == null) {
        return SyncOptions.syncWithCloud();
      }
      if (existingCloudNoteId.trim().isEmpty) {
        return SyncOptions.syncWithCloud();
      }
      return SyncOptions.syncWithExistingCloudId(existingCloudNoteId);
    }
    return SyncOptions.noSync();
  }

  String? getCloudNoteId() {
    return cloudId;
    // final syncOptions = this;
    // if (syncOptions is SyncWithExistingCloudIdOption) {
    //   return syncOptions.cloudId;
    // }
    // if (syncOptions.isSyncWithCloud) {
    //   return '';
    // }
    // return null;
  }
}

class NoSyncOption extends SyncOptions {
  const NoSyncOption._() : super();

  @override
  bool get isSyncWithCloud => false;

  @override
  String? get cloudId => null;

  @override
  String toString() {
    return "Don'n sync with the cloud, delete if it exists for updating note";
  }
}

class SyncWithCloudOption extends SyncOptions {
  const SyncWithCloudOption._() : super();

  static const emptyCloudNoteId = '';

  @override
  bool get isSyncWithCloud => true;

  @override
  String? get cloudId => emptyCloudNoteId;

  @override
  String toString() {
    return 'Sync with cloud by creating a new entry';
  }
}

class SyncWithExistingCloudIdOption extends SyncOptions {
  final String _cloudId;
  SyncWithExistingCloudIdOption._(this._cloudId) : super() {
    if (_cloudId.trim().isEmpty) {
      AppLogger.error(
          'Trying to sync cloud note id with existing note and that is empty!!');
      throw ArgumentError('cloud note id can not be empty!!');
    }
  }

  @override
  String? get cloudId => _cloudId;

  @override
  bool get isSyncWithCloud => true;

  @override
  String toString() {
    return 'Sync with existing cloud id = $cloudId';
  }
}
