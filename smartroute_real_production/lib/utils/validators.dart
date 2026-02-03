class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '전화번호를 입력해주세요';
    }
    final phoneRegex = RegExp(r'^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$');
    if (!phoneRegex.hasMatch(value.replaceAll('-', ''))) {
      return '올바른 전화번호 형식이 아닙니다';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName을(를) 입력해주세요';
    }
    return null;
  }

  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return '최소 $minLength자 이상 입력해주세요';
    }
    return null;
  }

  static String? validateMaxLength(String? value, int maxLength) {
    if (value != null && value.length > maxLength) {
      return '최대 $maxLength자까지 입력 가능합니다';
    }
    return null;
  }
}
