import 'dart:async';

class Validators {
  static const String _regEmail =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static const String _regPassword =
      r"^(?=.*\d)(?=.*[@#$%&*()_-])(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$"; // 8-character length, 1-symbol, 1-uppercase, 1-digit

  // [Email address validation]
  static final validateEmail = StreamTransformer.fromHandlers(
    handleData: (String email, EventSink<String> sink) {
      bool isValid = RegExp(_regEmail).hasMatch(email);
      if (isValid) {
        sink.add(email);
      } else if (email.isNotEmpty) {
        sink.addError("Invalid email address.");
      } else {
        sink.add("");
      }
    },
  );

  // [Password]
  static final validatePassword =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (String password, EventSink<String> sink) {
      bool isValid = RegExp(_regPassword).hasMatch(password);
      if (password.isEmpty) {
        sink.addError("");
      } else if (password.length >= 8 && isValid) {
        sink.add(password);
      } else if (password.length < 8) {
        sink.addError("Password at least 8 characters.");
      } else {
        sink.addError("Invalid password format.");
      }
    },
  );

  // VGN Number validation
  static final validateVGNReferenceNumber =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String? value, EventSink<String> sink) {
    if (value == null || value.trim().isEmpty) {
      sink.addError("Enter your number");
    } else if (value.trim().length < 13) {
      sink.addError("Enter valid number");
    }
  });

  // TRN Number validation
  static final validateTRNReferenceNumber =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String? value, EventSink<String> sink) {
    if (value == null || value.trim().isEmpty) {
      sink.addError("Enter your number");
    }
  });

  // DOB validation
  static final validateDOB = StreamTransformer<String, String>.fromHandlers(
      handleData: (String? value, EventSink<String> sink) {
    if (value!.isEmpty) {
      sink.addError("Select date of birth");
    }
  });

  // Country validation
  static final validateCountry = StreamTransformer<String, String>.fromHandlers(
      handleData: (String? value, EventSink<String> sink) {
    if (value!.isEmpty) {
      sink.addError("Select country");
    }
  });

  // Passport validation
  static final validatePassportNumber = StreamTransformer<String, String>.fromHandlers(
  handleData: (String? value, EventSink<String> sink) {
    String patttern = r'^(?!^0+$)[a-zA-Z0-9]{3,20}$';
    RegExp regExp = RegExp(patttern);
    if (value!.trim().isEmpty) {
  sink.addError("Enter Passport Number");
    } else if (!regExp.hasMatch(value.trim())) {
  sink.addError("Enter valid Passport Number");
    }
  });
}
