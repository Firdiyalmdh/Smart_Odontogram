import 'package:flutter/material.dart';
class MedicalExamButton extends StatelessWidget {
  final Rect labelPosition;
  final String labelText;
  final TextAlign labelAlign;
  final Rect iconPosition;
  final String iconAsset;
  final bool isFilled;
  final Rect checkPosition;
  final void Function() onTap;

  const MedicalExamButton({
    super.key,
    required this.labelPosition,
    required this.labelText,
    required this.labelAlign,
    required this.iconPosition,
    required this.iconAsset,
    required this.isFilled,
    required this.checkPosition,
    required this.onTap,
  });

  double? getOrNull(double value) => value == 0 ? null : value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFB4D5FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        highlightColor: const Color(0xFFBBD4F5),
        child: Stack(
          children: [
            Positioned(
              left: getOrNull(labelPosition.left),
              top: getOrNull(labelPosition.top),
              right: getOrNull(labelPosition.right),
              bottom: getOrNull(labelPosition.bottom),
              child: Text(
                labelText,
                textAlign: labelAlign,
                style: const TextStyle(
                  fontSize: 35,
                  height: .95,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Positioned(
              left: getOrNull(iconPosition.left),
              top: getOrNull(iconPosition.top),
              right: getOrNull(iconPosition.right),
              bottom: getOrNull(iconPosition.bottom),
              child: Image.asset(
                iconAsset,
                scale: 0.75,
              ),
            ),
            (isFilled) ? Positioned(
              left: getOrNull(checkPosition.left),
              top: getOrNull(checkPosition.top),
              right: getOrNull(checkPosition.right),
              bottom: getOrNull(checkPosition.bottom),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 36,
              ),
            ) : const SizedBox()
          ],
        ),
      ),
    );
  }
}