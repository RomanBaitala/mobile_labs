import 'package:equatable/equatable.dart';
import 'package:iot_flutter_lab/models/server.dart';

abstract class ServerState extends Equatable {
  const ServerState();

  @override
  List<Object?> get props => [];
}

class ServerInitial extends ServerState {}

class ServerLoading extends ServerState {}

class ServerLoaded extends ServerState {
  final List<ServerModel> servers;
  final bool isOffline;

  const ServerLoaded({required this.servers, this.isOffline = false});

  @override
  List<Object?> get props => [servers, isOffline];
}

class ServerError extends ServerState {
  final String message;

  const ServerError(this.message);

  @override
  List<Object?> get props => [message];
}
