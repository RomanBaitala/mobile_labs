import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/models/metric.dart';
import 'package:iot_flutter_lab/repositories/server_repository.dart';
import 'package:iot_flutter_lab/widgets/server_chart_card.dart';
import 'package:iot_flutter_lab/widgets/server_stat_card.dart';


class DashboardScreen extends StatefulWidget {
  final int serverId;
  const DashboardScreen({required this.serverId, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RemoteServerRepository _serverRepo = RemoteServerRepository();
  List<MetricModel> _allMetrics = [];
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _timer = Timer.periodic(
      const Duration(seconds: 30), (_) => _loadData(quiet: true)
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadData({bool quiet = false}) async {
    if (!quiet) setState(() => _isLoading = true);
    try {
      final metrics = await _serverRepo.getServerMetrics(widget.serverId);
      if (mounted) {
        setState(() {
          _allMetrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!quiet) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    final lastMetric = _allMetrics.isNotEmpty ?
       _allMetrics.reversed.toList().first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Server Monitoring')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : lastMetric == null
              ? const Center(child: Text('Дані відсутні'))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ServerChartCard(metrics: _allMetrics),
                      
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 
                          MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        padding: const EdgeInsets.all(16),
                        children: [
                          ServerStatCard(
                            title: 'CPU Load',
                            value: '${lastMetric.cpuUsage.toStringAsFixed(1)}%',
                            icon: Icons.memory,
                          ),
                          ServerStatCard(
                            title: 'RAM Usage',
                            value: 
                              '${lastMetric.memoryUsage.toStringAsFixed(1)}%',
                            icon: Icons.storage,
                          ),
                          ServerStatCard(
                            title: 'Temp',
                            value: 
                              '${lastMetric.cpuTemperature.toStringAsFixed(1)}'
                              '°C',
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
