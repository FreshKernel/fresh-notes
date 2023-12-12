import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../../../core/log/logger.dart';

class SyncOptionsJsonConverter
    extends JsonConverter<SyncOptions, Map<String, Object?>> {
  const SyncOptionsJsonConverter();
  @override
  SyncOptions fromJson(Map<String, Object?> json) {
    throw UnimplementedError();
  }

  @override
  Map<String, Object?> toJson(SyncOptions object) {
    return {
      'isSyncWithCloud': object.isSyncWithCloud,
      'cloudId': object.cloudId,
    };
  }
}

@immutable
// @JsonSerializable(converters: [SyncOptionsJsonConverter()])
sealed class SyncOptions extends Equatable {
  const SyncOptions();
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
  const SyncOptions._();

  bool get isSyncWithCloud;
  String? get cloudId;

  @override
  List<Object?> get props => [isSyncWithCloud, cloudId];

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
    return switch (option) {
      /// It does not exists and probably the it has no sync
      NoSyncOption() => false,
      SyncWithCloudOption() => false,
      SyncWithExistingCloudIdOption() => true,
    };
  }

  String? getCloudNoteId() {
    return cloudId;
  }
}

final class NoSyncOption extends SyncOptions {
  const NoSyncOption._() : super._();

  @override
  bool get isSyncWithCloud => false;

  @override
  String? get cloudId => null;

  @override
  String toString() {
    return "Don'n sync with the cloud, delete if it exists for updating note";
  }
}

final class SyncWithCloudOption extends SyncOptions {
  const SyncWithCloudOption._() : super._();

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

final class SyncWithExistingCloudIdOption extends SyncOptions {
  SyncWithExistingCloudIdOption._(this._cloudId) : super._() {
    if (_cloudId.trim().isEmpty) {
      AppLogger.error(
          'Trying to sync cloud note id with existing note and that is empty!!');
      throw ArgumentError('cloud note id can not be empty!!');
    }
  }
  final String _cloudId;

  @override
  String? get cloudId => _cloudId;

  @override
  bool get isSyncWithCloud => true;

  @override
  String toString() {
    return 'Sync with existing cloud id = $cloudId';
  }
}
