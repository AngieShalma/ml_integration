part of 'ml_integration_cubit.dart';

@immutable
sealed class MlIntegrationState {}

final class MlIntegrationInitial extends MlIntegrationState {}
final class MlIntegrationSucessState extends MlIntegrationState {}
final class MlIntegrationFailedState extends MlIntegrationState {}
