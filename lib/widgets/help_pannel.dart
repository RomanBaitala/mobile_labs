import 'package:flutter/material.dart';

class HelpPannel extends StatelessWidget {
  final bool state;
  const HelpPannel({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    if (!state) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 18, 30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueGrey),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blueGrey),
              SizedBox(width: 8),
              Text(
                'Доступні команди:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey
                )
              ),
            ],
          ),
          const Divider(color: Colors.blueGrey, thickness: 1, height: 20),
          _buildCommandItem('help', 'Показує доступні команди'),
          _buildCommandItem('close', 'Закриває панель допомоги'),
          _buildCommandItem('reset', 'Скидає прогрес до нуля'),
          _buildCommandItem('scan', 'Сканує область на наявність пристроїв'),
          _buildCommandItem('connect <name>', 
            'Підключається до \nпристрою'),
          _buildCommandItem('detect', 'Виявляє слабке місце в пристрої'),
          _buildCommandItem('attack <name>',
            'Атакує пристрій за допомогою \nвиявленої вразливості'),
          _buildCommandItem('get <file>', 
            'Отримує дані з пристрою \nпісля успішної атаки'),
        ],
      ),
    );
  }

  Widget _buildCommandItem(String command, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            command,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey
            )
          ),
          const SizedBox(width: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.blueGrey)
          )
        ],
      ),
    );
  }
}
