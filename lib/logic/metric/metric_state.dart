import 'package:equatable/equatable.dart';
import 'package:iot_flutter_lab/models/metric.dart';

abstract class MetricState extends Equatable {
  const MetricState();

  @override
  List<Object?> get props => [];
}

class MetricLoading extends MetricState {}

class MetricLoaded extends MetricState {
  final List<MetricModel> metrics;
  const MetricLoaded(this.metrics);

  @override
  List<Object?> get props => [metrics];
}

class MetricError extends MetricState {
  final String message;
  const MetricError(this.message);

  @override
  List<Object?> get props => [message];
}
