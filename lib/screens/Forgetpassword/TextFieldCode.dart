import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCode extends StatefulWidget {
  final int numberOfFields;
  final Function(List<String>) onTextFieldsChanged;

  TextFieldCode(
      {required this.numberOfFields, required this.onTextFieldsChanged});

  @override
  _TextFieldCodeState createState() => _TextFieldCodeState();
}

class _TextFieldCodeState extends State<TextFieldCode> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.numberOfFields, (index) => FocusNode());
    _controllers = List.generate(widget.numberOfFields, (index) {
      var controller = TextEditingController();
      _configureTextController(controller, index);
      return controller;
    });
  }

  void _configureTextController(TextEditingController controller, int index) {
    controller.addListener(() {
      if (controller.text.isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _controllers[index - 1].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[index - 1].text.length),
        );
      }
      // Notify the parent widget about the changes
      widget.onTextFieldsChanged(getTextFieldValues());
    });

    controller.addListener(() {
      if (controller.text.isEmpty && index < 5) {
        _focusNodes[index + 1].requestFocus();
        _controllers[index + 1].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[index + 1].text.length),
        );
      }
      // Notify the parent widget about the changes
      widget.onTextFieldsChanged(getTextFieldValues());
    });


  }

  List<String> getTextFieldValues() {
    return List.generate(
      widget.numberOfFields,
      (index) => _controllers[index].text,
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.numberOfFields,
        (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xFFFD784F),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(1)],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '-',
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  cursorColor: Colors.deepPurpleAccent,
                  onChanged: (value) {
                    if (value.isNotEmpty && index < widget.numberOfFields - 1) {
                      _focusNodes[index + 1].requestFocus();
                    }
                    // Notify the parent widget about the changes
                    widget.onTextFieldsChanged(getTextFieldValues());
                  },
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
