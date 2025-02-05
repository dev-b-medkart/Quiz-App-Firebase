class Validations {

  static String? numberValidator(String? value) {

    if ((value ?? '').isEmpty) {
      return "Please enter number of questions";
    }
    return null;
  }
  static String? timeValidator(String? value) {

    if ((value ?? '').isEmpty) {
      return "Please number of minutes";
    }
    return null;
  }


  static String? titleValidator(String? value) {

    if ((value ?? '').isEmpty) {
      return "Please enter title";
    }
    return null;
  }
}