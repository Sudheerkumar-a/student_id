import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:student_id/core/utils/mock_data.dart';
import 'package:student_id/data/datasource/remote_data_source.dart';
import 'package:student_id/data/model/login_model.dart';
import 'package:student_id/data/model/student_model.dart';
import 'package:student_id/data/model/upload_id_model.dart';
import 'package:student_id/data/model/zone_model.dart';
import 'package:student_id/domain/entities/login_entity.dart';
import 'package:student_id/domain/entities/student_entity.dart';
import 'package:student_id/domain/entities/upload_id_entity.dart';
import 'package:student_id/domain/repositories/api_repository.dart';
import 'package:student_id/domain/requests/student_request.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/zone.dart';

class ApisRepositoryImpl implements ApisRepository {
  final RemoteDataSource remoteDataSource;

  ApisRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Zones>>> getZones(String lookupId) async {
    try {
      final zonesModels = await remoteDataSource.getZones(
          path: "master/zone?lookupId=$lookupId");
      final zones = zonesModels.map((e) => e.toZone).toList();
      return Right(zones);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Zones>>> getInstitutes(
      {required String lookupId}) async {
    try {
      final zonesModels = await remoteDataSource.getZones(
          path: 'master/school?lookupId=$lookupId');
      final zones = zonesModels.map((e) => e.toZone).toList();
      return Right(zones);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Zones>>> getColleges() async {
    try {
      final zonesModels = mockColleges; //await remoteDataSource.getZones();
      final zones = zonesModels.map((e) => e.toZone).toList();
      return Right(zones);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Zones>>> getClasses() async {
    try {
      final zonesModels = mockClasses;
      // await remoteDataSource.getZones();
      final zones = zonesModels.map((e) => e.toZone).toList();
      return Right(zones);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Zones>>> getClassesColleges() async {
    try {
      final zonesModels = mockClasses;
      zonesModels.addAll(mockColleges);
      // await remoteDataSource.getZones();
      final zones = zonesModels.map((e) => e.toZone).toList();
      return Right(zones);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginEntity>> login(
      String username, String password) async {
    try {
      final loginModels = await remoteDataSource.login(username, password);
      final loginResponse = loginModels.toLoginEntity;
      return Right(loginResponse);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentEntity>>> getStudents(
      StudentRequest studentRequest) async {
    try {
      final studentModels =
          await remoteDataSource.getStudents(studentRequest: studentRequest);
      final studentResponse =
          studentModels.map((e) => e.toStudentEntity).toList();
      return Right(studentResponse);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadIdEntitiy>> uploadStudentId(
      StudentRequest studentRequest) async {
    try {
      final uploadIdModel = await remoteDataSource.uploadStudentId(
          studentRequest: studentRequest);
      final uploadIdResponse = uploadIdModel.toUploadIdEntitiy;
      return Right(uploadIdResponse);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadIdEntitiy>> updateStudentId(
      StudentRequest studentRequest) async {
    try {
      final uploadIdModel = await remoteDataSource.updateStudentId(
          studentRequest: studentRequest);
      final uploadIdResponse = uploadIdModel.toUploadIdEntitiy;
      return Right(uploadIdResponse);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadIdEntitiy>> updateStudentImage(
      StudentRequest studentRequest) async {
    try {
      final uploadIdModel = await remoteDataSource.updateStudentImage(
          studentRequest: studentRequest);
      final uploadIdResponse = uploadIdModel.toUploadIdEntitiy;
      return Right(uploadIdResponse);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
