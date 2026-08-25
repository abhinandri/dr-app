class Validators {
  Validators._();

  static String? required(String? v, {String message = 'Required'}) {
    if (v == null || v.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? v) {
    if (v == null) return 'Email is required';

    final value = v.trim();

    if (value.isEmpty) {
      return 'Email is required';
    }

    if (value.contains(' ')) {
      return 'Email must not contain spaces';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? password(String? v) {
    if (v == null) return 'Password is required';

    final value = v.trim();

    if (value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Minimum 6 characters';
    }

    if (value.contains(' ')) {
      return 'Password must not contain spaces';
    }

    return null;
  }
}
