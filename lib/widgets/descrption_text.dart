import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/small_text.dart';

class DescriptionText extends StatefulWidget {
  final String text;
  const DescriptionText({super.key, required this.text});

  @override
  State<DescriptionText> createState() => _DescriptionTextState();
}

class _DescriptionTextState extends State<DescriptionText> {
  late String firstHalfText;
  late String secondHalfText;

  bool hiddenText = true;
  double textHeight = AppDimension.screenHeight / 5.63;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalfText = widget.text.substring(0, textHeight.toInt());
      secondHalfText = widget.text.substring(
        textHeight.toInt() + 1,
        widget.text.length,
      );
    } else {
      firstHalfText = widget.text;
      secondHalfText = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          secondHalfText.isEmpty
              ? SmallText(text: firstHalfText, size: AppDimension.radius8 * 2)
              : Column(
                children: [
                  SmallText(
                    size: AppDimension.radius8 * 2,
                    text:
                        hiddenText
                            ? firstHalfText
                            : firstHalfText + secondHalfText,
                  ),
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          hiddenText ? '...voir plus' : ' voir moins',
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          hiddenText
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up,
                          color: AppColors.primaryColor,
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        hiddenText = !hiddenText;
                      });
                    },
                  ),
                ],
              ),
    );
  }
}
