import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:occusearch/app_style/text_style/app_text_style.dart';
import 'package:occusearch/app_style/theme/app_color_style.dart';
import 'package:occusearch/features/authentication/authentication_bloc.dart';

// ignore: must_be_immutable
class OTPInputTextFieldWidget extends StatelessWidget {
  AuthenticationBloc? _authBloc;
  FocusNode focusHideOtp;
  Function onKeyboardDoneClick;

  OTPInputTextFieldWidget(
    this.focusHideOtp,
    this.onKeyboardDoneClick, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _authBloc ??= RxBlocProvider.of<AuthenticationBloc>(context);
    return Stack(
      children: [
        Row(
          children: [
            OTPTextFieldWidget(textEditingController: _authBloc!.teOtpDigitOne),
            const SizedBox(
              width: 10.0,
            ),
            OTPTextFieldWidget(textEditingController: _authBloc!.teOtpDigitTwo),
            const SizedBox(
              width: 10.0,
            ),
            OTPTextFieldWidget(
                textEditingController: _authBloc!.teOtpDigitThree),
            const SizedBox(
              width: 10.0,
            ),
            OTPTextFieldWidget(
                textEditingController: _authBloc!.teOtpDigitFour),
            const SizedBox(
              width: 10.0,
            ),
            OTPTextFieldWidget(
                textEditingController: _authBloc!.teOtpDigitFive),
            const SizedBox(
              width: 10.0,
            ),
            OTPTextFieldWidget(textEditingController: _authBloc!.teOtpDigitSix),
          ],
        ),
        TextFormField(
          controller: _authBloc!.otpController,
          // focusNode: focusHideOtp,
          // autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onFieldSubmitted: (input) => onKeyboardDoneClick(),
          showCursor: false,
          cursorColor: Colors.transparent,
          enableInteractiveSelection: true,
          textInputAction: TextInputAction.done,
          onChanged: (String str) {
            if (str.isNotEmpty) {
              if (str.toString().substring(0, 1) != "") {
                _authBloc!.teOtpDigitOne.text = str.toString().substring(0, 1);
              }
              if (str.length > 1 && str.toString().substring(1, 2) != "") {
                _authBloc!.teOtpDigitTwo.text = str.toString().substring(1, 2);
              } else {
                _authBloc!.teOtpDigitTwo.text = "";
              }
              if (str.length > 2 && str.toString().substring(2, 3) != "") {
                _authBloc!.teOtpDigitThree.text =
                    str.toString().substring(2, 3);
              } else {
                _authBloc!.teOtpDigitThree.text = "";
              }
              if (str.length > 3 && str.toString().substring(3, 4) != "") {
                _authBloc!.teOtpDigitFour.text = str.toString().substring(3, 4);
              } else {
                _authBloc!.teOtpDigitFour.text = "";
              }
              if (str.length > 4 && str.toString().substring(4, 5) != "") {
                _authBloc!.teOtpDigitFive.text = str.toString().substring(4, 5);
              } else {
                _authBloc!.teOtpDigitFive.text = "";
              }
              if (str.length > 5 && str.toString().substring(5, 6) != "") {
                _authBloc!.teOtpDigitSix.text = str.toString().substring(5, 6);
              } else {
                _authBloc!.teOtpDigitSix.text = "";
              }
            } else {
              _authBloc!.teOtpDigitTwo.text = "";
              _authBloc!.teOtpDigitThree.text = "";
              _authBloc!.teOtpDigitFour.text = "";
              _authBloc!.teOtpDigitOne.text = "";
              _authBloc!.teOtpDigitFive.text = "";
              _authBloc!.teOtpDigitSix.text = "";
            }
          },
          style: const TextStyle(fontSize: 0.1),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: AppColorStyle.backgroundVariant(context),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class OTPTextFieldWidget extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  OTPTextFieldWidget({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: textEditingController,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {},
        textAlign: TextAlign.center,
        onChanged: (String str) {
          if (str.isNotEmpty) {}
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: AppColorStyle.backgroundVariant(context),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        ),
        style: TextStyle(
            fontFamily: FontsHelper.notosansSemiBold,
            fontSize: 18,
            color: AppColorStyle.text(context)),
      ),
    );
  }
}
