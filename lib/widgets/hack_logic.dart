class HackLogic {
  final String message;
  final int progressChange;
  final bool? showHelp;

  HackLogic(
    this.message,
    this.progressChange,
    {this.showHelp}
  );
}

HackLogic processCommand(String input, int curProgress){
  final String cmd = input.toLowerCase().trim();

  switch(cmd){
    case 'scan':
      return curProgress == 0 ? 
      HackLogic('Сканування... Виявлено пристрій ESP32!', 1) : 
      HackLogic('Ви вже виявили пристрій. Спробуйте іншу команду.', 0);
    case 'connect esp32':
      return curProgress == 1 ? 
      HackLogic('Підключення до ESP32... Успішно!', 1) : 
      HackLogic('Спочатку потрібно виявити пристрій командою "scan".', 0);
    case 'detect':
      return curProgress == 2 ? 
      HackLogic('Виявлення вразливості... \nЗнайдено слабке crypto!', 1) : 
      HackLogic('Спочатку потрібно підключитися до пристрою'
        '\nза допомогою команди "connect".', 0);
    case 'attack crypto':
      return curProgress == 3 ? 
      HackLogic('Атака на ESP32... Успішно!'
        '\nВи отримали доступ до даних wallet.', 1) : 
      HackLogic('Спочатку потрібно виявити вразливість за'
        '\nдопомогою команди "detect".', 0);
    case 'get wallet':
      return curProgress == 4 ? 
      HackLogic('Отримання даних... Успішно!'
        '\nВи отримали конфіденційні дані з ESP32.', 1) : 
      HackLogic('Спочатку потрібно атакувати пристрій за'
        '\nдопомогою команди "attack".', 0);
    case 'reset':
      return HackLogic('Прогрес скинуто!', -curProgress);
    case 'help':
      return HackLogic('Доступні команди', 0, showHelp: true);
    case 'close':
      return HackLogic('Панель допомоги закрита', 0, showHelp: false);
    default:
      return HackLogic('Неправильна команда. Втрата одиниці прогресу!',
        curProgress > 0 ? -1 : 0);
  }
}
