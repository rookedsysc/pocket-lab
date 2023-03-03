import 'package:flutter/material.dart';

class InputTile extends StatelessWidget {
  final String fieldName;
  final Widget inputField;
  final String? hint;

  const InputTile(
      {this.hint,
      required this.fieldName,
      required this.inputField,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: hint == null ? 70.0 : 50.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //# field Name
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    fieldName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 14),
                  ),
                ),
                //# field
                Container(
                  height: 38.0,
                  //: 입력하면 글자가 옆에 딱 달라붙어 있어서 보기 싫음
                  padding: EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(child: inputField)),
              ],
            ),
            //# hint
            if (hint != null)
              Text(
                hint!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 10, color: Colors.red),
                textAlign: TextAlign.start,
              )
          ],
        ),
      ),
    );
  }
}
