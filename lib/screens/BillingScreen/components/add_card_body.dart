// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gp1_flutter/Rest/add_card_api.dart';
import 'package:gp1_flutter/Rest/profile_api.dart';
import 'package:gp1_flutter/Rest/update_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gp1_flutter/constants/color.dart';

class AddCardBody extends StatefulWidget {
  const AddCardBody({super.key});

  @override
  State<AddCardBody> createState() => _AddCardBodyState();
}

class _AddCardBodyState extends State<AddCardBody> {
  late SharedPreferences _sharedPreferences;
  TextEditingController num = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: SafeArea(
        child: Column(
          children: [
            Form(
                child: Column(
              children: [
                TextField(
                  controller: num,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter(),
                  ],
                  decoration: const InputDecoration(
                      hintText: 'Card number',
                      suffixIcon:
                          Image(image: AssetImage('assets/images/visa.png')),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Icon(
                          Icons.credit_card,
                        ),
                      )),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                      hintText: 'Full name',
                      prefixIcon: Icon(Icons.person_3_outlined)),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: cvv,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: const InputDecoration(
                          hintText: 'CVV',
                          prefixIcon: Image(
                              image: AssetImage('assets/images/cvv.png'))),
                    )),
                    const SizedBox(width: 40),
                    Expanded(
                        child: TextField(
                      controller: date,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        CardMonthInputFormatter()
                      ],
                      decoration: const InputDecoration(
                        hintText: 'MM/YY',
                        prefixIcon: Icon(Icons.date_range_outlined),
                      ),
                    )),
                  ],
                )
              ],
            )),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  num.text.isNotEmpty &&
                          name.text.isNotEmpty &&
                          cvv.text.isNotEmpty &&
                          date.text.isNotEmpty
                      ? createCard(
                          int.parse(num.text.toString().replaceAll(' ', '')),
                          name.text.toString(),
                          int.parse(cvv.text.toString()),
                          date.text.toString())
                      : ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All Field required")),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                child: const Text(
                  'Add Card',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  createCard(int cardNum, String cardName, int cvv, String date) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String email = _sharedPreferences.getString('useremail')!;

    var numberOfCard = await userProfile(email);

    int numOfCard = 0;
    if (numberOfCard['success']) {
      numOfCard = numberOfCard['user'][0]['card'];
      numOfCard++;

      var res = await userAddCard(email, cardNum, cardName, cvv, date);

      if (res['success']) {
        var resUpdate = await updateProfileHasCard(email, numOfCard.toString());
        if (resUpdate['success']) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacementNamed('/billingDetails');
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Credit Card added Successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Try again?')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Try again?')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Try again!")),
      );
    }
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;
      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();

    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && newText.length != nonZeroIndex) {
        buffer.write("/");
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
