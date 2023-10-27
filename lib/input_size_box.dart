import 'package:flutter/material.dart';
import 'package:jarvis/constant.dart';
import 'package:jarvis/pallete.dart';

class InputSizedBox extends StatelessWidget {
  InputSizedBox({
    super.key,
    required TextEditingController textEditingController,
    required this.onPressed,
  }) : _textEditingController = textEditingController;

  final TextEditingController _textEditingController;
  void clearInputField() {
    _textEditingController.clear();
  }

  final VoidCallback? onPressed;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Type your question...',
              fillColor: myColor, // Background color
              filled: true,
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
              hintStyle: TextStyle(color: Colors.grey[50]),
              suffixIcon: TextButton(
                onPressed: () {
                  if (_focusNode.hasFocus) {
                    _focusNode.unfocus();
                  }
                  onPressed!();
                  clearInputField();
                },
                child: const Icon(
                  Icons.double_arrow_outlined,
                  color: Colors.white,
                ),
              ),
              // Set the text input color here:
              // You can modify the color based on your preference.
              // Example: Changing the text color to red
              // textInputAction: TextStyle(color: Colors.red),
            ),
            style:
                const TextStyle(color: Colors.white), // Set the text color here
            onSubmitted: (_) {
              onPressed!();
            },
          )),
        ],
      ),
    );
  }
}
