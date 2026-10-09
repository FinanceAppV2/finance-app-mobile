import 'package:fpdart/fpdart.dart';

import '../datasources/notification_remote_datasource.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, Notification>> create({
    required String title,
    required String message,
    String type = 'INFO',
  }) async {
    try {
      final model = await _remoteDataSource.create(
        title: title,
        message: message,
        type: type,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao criar notificação: $e');
    }
  }

  @override
  Future<Either<String, Notification>> findById(String id) async {
    try {
      final model = await _remoteDataSource.findById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao buscar notificação: $e');
    }
  }

  @override
  Future<Either<String, List<Notification>>> findAllByUserId({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final models = await _remoteDataSource.findAllByUserId(limit: limit, offset: offset);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao listar notificações: $e');
    }
  }

  @override
  Future<Either<String, List<Notification>>> findUnreadByUserId() async {
    try {
      final models = await _remoteDataSource.findUnreadByUserId();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao listar notificações não lidas: $e');
    }
  }

  @override
  Future<Either<String, int>> countUnreadByUserId() async {
    try {
      final result = await _remoteDataSource.countUnreadByUserId();
      final count = result['count'] as int? ?? 0;
      return Right(count);
    } catch (e) {
      return Left('Erro ao contar notificações não lidas: $e');
    }
  }

  @override
  Future<Either<String, Notification>> markAsRead(String id) async {
    try {
      final model = await _remoteDataSource.markAsRead(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao marcar notificação como lida: $e');
    }
  }

  @override
  Future<Either<String, int>> markAllAsReadByUserId() async {
    try {
      final result = await _remoteDataSource.markAllAsReadByUserId();
      final count = result['count'] as int? ?? 0;
      return Right(count);
    } catch (e) {
      return Left('Erro ao marcar todas as notificações como lidas: $e');
    }
  }

  @override
  Future<Either<String, Notification>> update(
    String id, {
    String? title,
    String? message,
    String? type,
    bool? read,
  }) async {
    try {
      final model = await _remoteDataSource.update(
        id,
        title: title,
        message: message,
        type: type,
        read: read,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left('Erro ao atualizar notificação: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remoteDataSource.delete(id);
      return const Right(null);
    } catch (e) {
      return Left('Erro ao deletar notificação: $e');
    }
  }

  @override
  Future<Either<String, int>> deleteByUserId() async {
    try {
      final result = await _remoteDataSource.deleteByUserId();
      final count = result['count'] as int? ?? 0;
      return Right(count);
    } catch (e) {
      return Left('Erro ao deletar notificações: $e');
    }
  }
}
