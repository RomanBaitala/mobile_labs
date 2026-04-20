import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab/logic/metric/metric_cubit.dart';
import 'package:iot_flutter_lab/logic/metric/metric_state.dart';
import 'package:iot_flutter_lab/models/metric.dart';
import 'package:iot_flutter_lab/repositories/server_repository.dart';
import 'package:iot_flutter_lab/widgets/server_chart_card.dart';
import 'package:iot_flutter_lab/widgets/server_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  final int serverId;
  const DashboardScreen({required this.serverId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MetricCubit(context.read<RemoteServerRepository>())
            ..startMonitoring(serverId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Server Monitoring')),
        body: BlocBuilder<MetricCubit, MetricState>(
          builder: (context, state) {
            if (state is MetricLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }
            if (state is MetricError) {
              return Center(child: Text(state.message));
            }
            if (state is MetricLoaded) {
              return _DashboardBody(metrics: state.metrics);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final List<MetricModel> metrics;
  const _DashboardBody({required this.metrics});

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const Center(child: Text('Дані відсутні'));

    final lastMetric = metrics.last;

    return SingleChildScrollView(
      child: Column(
        children: [
          ServerChartCard(metrics: metrics),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            padding: const EdgeInsets.all(16),
            children: [
              ServerStatCard(
                title: 'CPU Load',
                value: '${lastMetric.cpuUsage.toStringAsFixed(1)}%',
                icon: Icons.memory,
              ),
              ServerStatCard(
                title: 'RAM Usage',
                value: '${lastMetric.memoryUsage.toStringAsFixed(1)}%',
                icon: Icons.storage,
              ),
              ServerStatCard(
                title: 'Temp',
                value: '${lastMetric.cpuTemperature.toStringAsFixed(1)}°C',
                icon: Icons.thermostat,
              ),
              ServerStatCard(
                title: 'Updated',
                value: _formatTime(lastMetric.timestamp),
                icon: Icons.access_time,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final localTime = time.toLocal();
    return "${localTime.hour.toString().padLeft(2, '0')}:"
        "${localTime.minute.toString().padLeft(2, '0')}:"
        "${localTime.second.toString().padLeft(2, '0')}";
  }
}
