import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/home/view/widget/color_picker_alert_dialog.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class CategoryInputModalScreen extends ConsumerStatefulWidget {
  TransactionCategory? category;
  final bool isEdit; 
  CategoryInputModalScreen({required this.isEdit,this.category,super.key});

  @override
  ConsumerState<CategoryInputModalScreen> createState() => _CategoryInputModalScreenState();
}

class _CategoryInputModalScreenState extends ConsumerState<CategoryInputModalScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void didChangeDependencies() {
    if (widget.category == null) {
      widget.category = TransactionCategory(color: '', name: '');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return InputModalScreen(
        scrollController: _scrollController,
        isEdit: widget.isEdit,
        formKey: _formKey,
        inputTile: _inputTileList(),
        onSavePressed: _onSavePressed());
  }

  List<InputTile> _inputTileList() {
    return [
      _categoryNameInputTile(),
      _colorPickerInputTile()
    ];
  }

  InputTile _colorPickerInputTile() {
    return InputTile(
        fieldName: "",
        inputField: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => ColorPickerAlertDialog());
          },
          child: Text(
            "Color Picker",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: ref.watch(colorProvider.notifier).state),
          ),
        ));
  }

  InputTile _categoryNameInputTile() {
    return InputTile(
      fieldName: "Category Name",
      inputField: TextTypeTextFormField(
        hintText: widget.isEdit == true ? widget.category!.name : null,
        onSaved: (newValue) {
          widget.category!.name = newValue!;
        },
        validator: (value) {
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
      widget.category!.color =
          ColorUtils.colorToHexString(ref.watch(colorProvider.notifier).state);
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await ref
            .watch(categoryRepositoryProvider.notifier)
            .configCategory(widget.category!);
        Navigator.pop(context);
      }
    };
  }
}
