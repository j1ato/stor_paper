import 'package:dartz/dartz.dart';
import 'package:stor_paper/domain/auth/auth_failure.dart';
import 'package:stor_paper/domain/auth/value_objects.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
  required EmailAddress emailAddress,
  required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });

  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}