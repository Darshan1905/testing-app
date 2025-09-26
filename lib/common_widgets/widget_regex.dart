class Regex {
  // email validation
  static String? validateEmail(String? value) {
    String patttern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(patttern);
    if (value!.trim().isEmpty) {
      return 'Enter email address';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // email validation without empty condition
  static String? validateEmailRegex(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value!)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // phone number validation
  static String? validateMobile(String? value) {
    String pattern = r'(^(\d{1,4}[- ]?)?\d{6,15}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.trim().isEmpty) {
      return 'Enter phone number';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid phone number';
    }
    return null;
  }

  // phone number validation without empty condition
  static String? validateMobileRegex(String? value) {
    String pattern = r'(^(\d{1,4}[- ]?)?\d{6,15}$)';
    RegExp regExp = RegExp(pattern);
    if (value!.trim().isNotEmpty && !regExp.hasMatch(value)) {
      return 'Enter valid phone number';
    }
    return null;
  }

  // date validation
  static String? validateDate(String? value) {
    if (value!.isEmpty) {
      return 'Please select date';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    RegExp regExp = RegExp('[a-z A-Z\s]');
    if (value!.trim().isEmpty) {
      return 'Enter full name';
    } else if (!regExp.hasMatch(value) || value.length < 3) {
      return 'Enter valid name';
    }
    return null;
  }

  // Number validation
  static validateNumber(String? value) {
    if (value!.isEmpty) {
      return 'Enter your number';
    }
    return null;
  }

  // Passport validation
  static validatePassportNumber (String? value) {
    String pattern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Enter Passport Number';
    } else if (!regExp.hasMatch(value)) {
      return 'Enter valid Passport Number';
    }
    return null;
  }

  // DOB validation
  static validateDOB(String? value) {
    if (value!.isEmpty) {
      return 'Enter date of birth';
    }
    return null;
  }

  // Country validation
  static validateCountry(String? value) {
    if (value!.isEmpty) {
      return 'Enter country';
    }
    return null;
  }
}
