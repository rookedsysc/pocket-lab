import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/view/widget/color_picker_alert_dialog.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class CategoryInputModalScreen extends ConsumerStatefulWidget {
  TransactionCategory? category;
  final bool isEdit;
  CategoryInputModalScreen({required this.isEdit, this.category, super.key});

  @override
  ConsumerState<CategoryInputModalScreen> createState() =>
      _CategoryInputModalScreenState();
}

class _CategoryInputModalScreenState
    extends ConsumerState<CategoryInputModalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputModalScreen(
        isDelButton: widget.isEdit,
        onDelPressed: () async {
          await ref
              .read(categoryRepositoryProvider.notifier)
              .deleteCategory(widget.category!);
          await ref
              .read(transactionRepositoryProvider.notifier)
              .handleDeletedCategoryInTransactions(
                  categoryId: widget.category!.id);

          Navigator.pop(context);
        },
        scrollController: _scrollController,
        isEdit: widget.isEdit,
        formKey: _formKey,
        inputTile: _inputTileList(),
        onSavePressed: _onSavePressed());
  }

  List<InputTile> _inputTileList() {
    return [
      _categoryNameInputTile(),
      _colorPickerInputTile(),
    ];
  }

  InputTile _colorPickerInputTile() {
    return InputTile(
        fieldName: "",
        inputField: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => ColorPickerAlertDialog(
                      onColorChanged: _onColorChanged(ref),
                    ));
          },
          child: Text(
            "category input modal screen.color picker".tr(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: ref.watch(colorProvider.notifier).state,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  _onColorChanged(WidgetRef ref) {
    return (Color color) {
      ref.read(colorProvider.notifier).update((state) => color);
      if (widget.category != null) {
        widget.category!.color = ColorUtils.colorToHexString(color);
      }

      if (mounted) {
        setState(() {});
      }
    };
  }

  InputTile _categoryNameInputTile() {
    return InputTile(
      fieldName: "category input modal screen.name".tr(),
      inputField: TextTypeTextFormField(
        hintText: widget.isEdit == true ? widget.category!.name : null,
        onSaved: (newValue) {
          if (newValue != null && newValue.isNotEmpty) {
            widget.category!.name = newValue;
          }
          return;
        },
        validator: widget.isEdit
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
        onTap: () {},
      ),
    );
  }

  VoidCallback _onSavePressed() {
    return () async {
      if (_formKey.currentState!.validate()) {
        if (widget.category == null) {
          String _color = ColorUtils.colorToHexString(
              ref.read(colorProvider.notifier).state);
          widget.category =
              TransactionCategory(color: _color, name: 'initail name');
        }
        _formKey.currentState!.save();
        await ref
            .read(categoryRepositoryProvider.notifier)
            .configCategory(category: widget.category!, isEdit: widget.isEdit);
        Navigator.pop(context);
      }
    };
  }
}
