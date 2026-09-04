import 'package:fpdart/fpdart.dart';

import '../../domain/entities/loan.dart';
import '../../domain/repositories/loan_repository.dart';
import '../datasources/loan_remote_datasource.dart';

class LoanRepositoryImpl implements LoanRepository {
  final LoanRemoteDataSource _remoteDataSource;

  LoanRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<String, List<Loan>>> getLoans() async {
    try {
      final response = await _remoteDataSource.getLoans();
      return Right(response.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao buscar empréstimos: $e');
    }
  }

  @override
  Future<Either<String, Loan>> getLoanById(String id) async {
    try {
      final response = await _remoteDataSource.getLoanById(id);
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao buscar empréstimo: $e');
    }
  }

  @override
  Future<Either<String, Loan>> createLoan({
    required String description,
    required double totalValue,
    required int totalInstallments,
    required DateTime startDate,
    double monthlyInterestRate = 0,
  }) async {
    try {
      final response = await _remoteDataSource.createLoan(
        description: description,
        totalValue: totalValue,
        totalInstallments: totalInstallments,
        startDate: startDate,
        monthlyInterestRate: monthlyInterestRate,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao criar empréstimo: $e');
    }
  }

  @override
  Future<Either<String, Loan>> updateLoan({
    required String id,
    String? description,
    double? totalValue,
    int? totalInstallments,
    double? monthlyInterestRate,
    DateTime? startDate,
    bool? active,
  }) async {
    try {
      final response = await _remoteDataSource.updateLoan(
        id: id,
        description: description,
        totalValue: totalValue,
        totalInstallments: totalInstallments,
        monthlyInterestRate: monthlyInterestRate,
        startDate: startDate,
        active: active,
      );
      return Right(response.toEntity());
    } catch (e) {
      return Left('Erro ao atualizar empréstimo: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteLoan(String id) async {
    try {
      await _remoteDataSource.deleteLoan(id);
      return const Right(null);
    } catch (e) {
      return Left('Erro ao excluir empréstimo: $e');
    }
  }

  @override
  Future<Either<String, List<Loan>>> getActiveLoans({
    required int month,
    required int year,
  }) async {
    try {
      final response = await _remoteDataSource.getActiveLoans(
        month: month,
        year: year,
      );
      return Right(response.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left('Erro ao buscar empréstimos ativos: $e');
    }
  }
}
