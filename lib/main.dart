import 'package:flutter/material.dart';
import 'package:iot_flutter_lab/widgets/hack_logic.dart';
import 'package:iot_flutter_lab/widgets/help_pannel.dart';
import 'package:iot_flutter_lab/widgets/icon.dart';
import 'package:iot_flutter_lab/widgets/progress_bar.dart';
import 'package:iot_flutter_lab/widgets/terminal_input.dart';



void main() {
  runApp(const IoTLabApp());
}

class IoTLabApp extends StatelessWidget {
  const IoTLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Flutter Lab 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hack IoT Device'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _progress = 0;
  bool _showHelp = false;
  final TextEditingController _controller = TextEditingController();

  String _message = 'Введіть команду для взаємодії з пристроєм';

  void _handleInput(String input) {
    final String input = _controller.text.trim();
    
    final response = processCommand(input, _progress);
    setState(() {
      _message = response.message;
      _progress += response.progressChange;
      if (response.showHelp != null) _showHelp = response.showHelp!;
    });
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Hack IoT Device', 
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.green
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Row(
              children: [
                Icon(
                  Icons.lock_open,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'Прогрес взлому:',
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.green
                  )
                )
              ],
            ),
            const SizedBox(height: 18),
            ProgressBar(progress: _progress),
            const SizedBox(height: 30),
            TerminalInput(
              controller: _controller,
              onSubmitted:  _handleInput,
            ),
            const SizedBox(height: 16),
            Text(_message,
              style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              )
            ),
            const SizedBox(height: 30),
            HelpPannel(state: _showHelp),
            const SizedBox(height: 30),
            const CustomIcon(),
          ],
        ),
      ),
    );
  }
}
