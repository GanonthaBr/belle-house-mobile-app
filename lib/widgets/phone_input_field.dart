import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/country_helper_code.dart';
import 'package:mobile_app/utils/dimensions.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  const PhoneInputField({super.key, required this.controller});

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String? initialCountryCode = 'NE';

  @override
  void initState() {
    super.initState();
    _loadInitialCountryCode();
  }

  Future<void> _loadInitialCountryCode() async {
    final code = await CountryCodeHelper.getInitialCountryCode();
    // print(code);
    setState(() {
      initialCountryCode = code;
      // print(code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: IntlPhoneField(
        controller: widget.controller,
        initialCountryCode: initialCountryCode,
        decoration: InputDecoration(
          helper: Text('Entrer votre numero de Téléphone'),
          labelText: 'Numéro de téléphone',
          labelStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.4,
            color: AppColors.secondaryColor,
          ),
          filled: true,
          fillColor: AppColors.primaryColor,
          focusColor: AppColors.primaryColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimension.radius14),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimension.radius14),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
        ),
        onChanged: (phone) {},
      ),
    );
  }
}
