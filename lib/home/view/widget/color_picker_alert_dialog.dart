import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final colorProvider = StateProvider<Color>((ref) {
  return Colors.blue;
});

class ColorPickerAlertDialog extends ConsumerWidget {
  final ValueChanged<Color> onColorChanged;
  
  const ColorPickerAlertDialog({required this.onColorChanged,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: MediaQuery.of(context).orientation == Orientation.portrait
            ? const BorderRadius.vertical(
                top: Radius.circular(500),
                bottom: Radius.circular(100),
              )
            : const BorderRadius.horizontal(right: Radius.circular(500)),
      ),
      content: SingleChildScrollView(
        child: HueRingPicker(
          pickerColor: ref.watch(colorProvider),
          onColorChanged: onColorChanged,
          enableAlpha: false,
          displayThumbColor: true,
        ),
      ),
    );
  }

}
