import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_id/core/network/dio_client.dart';
import 'package:student_id/core/network/remote_data_store.dart';

final dioProvider = Provider((ref) => createDio());

final remoteDataStoreProvider = Provider<RemoteDataStore>(
  (ref) => RemoteDataStore(ref.watch(dioProvider)),
);
