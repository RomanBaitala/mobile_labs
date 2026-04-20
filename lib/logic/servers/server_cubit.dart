import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/servers/server_state.dart';
import 'package:iot_flutter_lab/models/server.dart';
import 'package:iot_flutter_lab/repositories/iserver_repository.dart';

class ServerCubit extends Cubit<ServerState> {
  final IServerRepository _repository;

  ServerCubit(this._repository) : super(ServerInitial());

  Future<void> fetchServers() async {
    emit(ServerLoading());
    try {
      final servers = await _repository.getServers();
      emit(ServerLoaded(servers: servers));
    } catch (e) {
      emit(ServerError(e.toString()));
    }
  }

  Future<void> deleteServer(int id) async {
    try {
      final success = await _repository.deleteServer(id);
      if (success) {
        await fetchServers();
      }
    } catch (e) {
      emit(const ServerError('Не вдалося видалити сервер'));
    }
  }

  Future<void> addServer(String name, String ip) async {
    List<ServerModel> currentServers = [];
    if (state is ServerLoaded) {
      currentServers = (state as ServerLoaded).servers;
    }

    emit(ServerLoading());
    try {
      final success = await _repository.addServer(name, ip);
      if (success) {
        await fetchServers();
      } else {
        emit(ServerLoaded(servers: currentServers));
        emit(const ServerError('Не вдалося додати сервер (помилка АПІ)'));
      }
    } catch (e) {
      emit(ServerLoaded(servers: currentServers));
      emit(ServerError(e.toString()));
    }
  }

  void setOfflineMode() {
    if (state is ServerLoaded) {
      final currentServers = (state as ServerLoaded).servers;
      final offlineServers = currentServers
          .map((s) => s.copyWith(status: ServerStatus.unknown))
          .toList();
      emit(ServerLoaded(servers: offlineServers, isOffline: true));
    }
  }
}
