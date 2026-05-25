import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/metric/metric_state.dart';
import 'package:iot_flutter_lab/repositories/iserver_repository.dart';

class MetricCubit extends Cubit<MetricState> {
  final IServerRepository _repository;
  Timer? _timer;

  MetricCubit(this._repository) : super(MetricLoading());

  void startMonitoring(int serverId) {
    loadMetrics(serverId);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadMetrics(serverId, quiet: true);
    });
  }

  Future<void> loadMetrics(int serverId, {bool quiet = false}) async {
    if (!quiet) emit(MetricLoading());
    try {
      final metrics = await _repository.getServerMetrics(serverId);
      emit(MetricLoaded(metrics));
    } catch (e) {
      if (!quiet) emit(MetricError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
