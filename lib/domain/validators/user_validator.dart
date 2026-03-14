class UserValidator {
  static String? validateEmail(String? value) {
    if (value == null || !value.contains('@')) {
      return 'Невірний формат пошти';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null) {
      return 'Введіть всі необхідні поля';
    } else if (value.length < 6) {
      return 'Довжина паролю повинна бути не менше 6 символів';
    }
    return null;
  }

  static String? validateCompPassword(String? password, String? compPassword) {
    if (password == null || compPassword == null) {
      return 'Введіть всі необхідні поля';
    } else if (password != compPassword) {
      return 'Паролі не збігаються';
    }
    return null;
  }
}
