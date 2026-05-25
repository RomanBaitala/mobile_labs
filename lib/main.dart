import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Cubit
import 'package:iot_flutter_lab/logic/auth/auth_cubit.dart';
import 'package:iot_flutter_lab/logic/metric/metric_cubit.dart';
import 'package:iot_flutter_lab/logic/servers/server_cubit.dart';
// repositroy
import 'package:iot_flutter_lab/repositories/auth_repository.dart';
import 'package:iot_flutter_lab/repositories/server_repository.dart';
// Screens
import 'package:iot_flutter_lab/screens/charge.dart';
import 'package:iot_flutter_lab/screens/dashboard.dart';
import 'package:iot_flutter_lab/screens/login.dart';
import 'package:iot_flutter_lab/screens/profile.dart';
import 'package:iot_flutter_lab/screens/register.dart';
import 'package:iot_flutter_lab/screens/server_list.dart';


void main() {
  final serverRepository = RemoteServerRepository();
  final authRepo = RemoteAuthRepository();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RemoteAuthRepository>(create: (_) => authRepo),
        RepositoryProvider<RemoteServerRepository>(
          create: (context) => serverRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepo)..checkAuth(),
          ),
          BlocProvider<ServerCubit>(
            create: (context) => ServerCubit(serverRepository)..fetchServers(),
          ),
          BlocProvider<MetricCubit>(
            create: (context) => MetricCubit(serverRepository),
          ),
        ],
        child: const HomeServerApp(),
      ),
    ),
  );
}

class HomeServerApp extends StatelessWidget {
  const HomeServerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Server Monitor',
      theme: _buildTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/servers': (context) => const ServerListScreen(),
        '/battery': (context) => const ChargingPage(),
      },
      onGenerateRoute: _onGenerateRoute,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 2,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      useMaterial3: true,
    );
  }

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/home') {
      final args = settings.arguments;
      if (args is int) {
        return MaterialPageRoute(
          builder: (context) => DashboardScreen(serverId: args),
        );
      }
    }
    return null;
  }
}
