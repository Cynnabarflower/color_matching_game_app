import 'dart:math';

import 'package:color_matching_game/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

String username = '';
String birthday = '';
String gender = '';

class RegistrationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  var selected = [false, false];

  var femaleImage = AssetImage('images/girl.png');
  var maleImage = AssetImage('images/man.png');
  var _dateController = TextEditingController();
  var _nameController = TextEditingController();
  bool licenseChecked = false;
  final _formKey = GlobalKey<FormState>();
  bool shakeGender = false;
  var maskFormatter = new MaskTextInputFormatter(mask: '##.##.####', filter: { "#": RegExp(r'[0-9]'), });

  @override
  void initState() {
    selected = Random().nextBool() ? [true, false] : [false, true];
    gender = selected[0] ? 'M' : 'F';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    print(s);

    if (s.width < MIN_WIDTH || s.height < MIN_HEIGHT) {
      return smallScreen();
    }

    print(shakeGender);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          color: Colors.lightBlueAccent,
          child: LayoutBuilder(builder: (context, constrains) {
            return LimitedBox(
              maxWidth: constrains.maxWidth / 5,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Card(
                  elevation: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Container(
                          color: Colors.white,
                          child:
                              Form(
                                key: _formKey,
                                child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      lang == 'ru' ? 'Регистраия' : 'Registration',
                                    style: TextStyle(
                                        color: Colors.lightBlue, fontSize: 50),
                                  ),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LayoutBuilder(
                                  builder: (context, c) => ToggleButtons(
                                    constraints: BoxConstraints.expand(
                                        width: c.maxWidth / 2),
                                    renderBorder: false,
                                    isSelected: selected,
                                    color: Colors.lightBlueAccent[100],
                                    selectedColor: Colors.red[400],
                                    splashColor: Colors.transparent,
                                    onPressed: (index) {
                                      setState(() {
                                        selected[0] = false;
                                        selected[1] = false;
                                        selected[index] = true;
                                      });
                                    },
                                    children: [
                                      Opacity(
                                          opacity: selected[0] ? 1 : 0.4,
                                          child:
                                          getGenderButton("Male", maleImage),
                                              ),
                                      Opacity(
                                          opacity: selected[1] ? 1 : 0.4,
                                          child: getGenderButton("Female", femaleImage))
                                    ],
                                  ),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return lang == 'ru' ? 'Сюда надо что-то написать, лучше - имя' : 'Please enter something here, for example - your name';
                                    }
                                    if (value.toLowerCase() == 'имя' || value.toLowerCase() == 'your name' || value.toLowerCase() == 'name') {
                                      return lang == 'ru' ? 'Ха-ха очень смешно' : 'Ha-ha very funny';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: lang == 'ru' ? 'Имя' : 'Name',
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                  ),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _dateController,
                                  inputFormatters: [maskFormatter],
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return lang == 'ru' ? 'Это тоже надо заполнить' : 'This field is also required';
                                    } else {
                                      var d = myDateParse(_dateController.text);
                                      if (d != null) {
                                        if (d.year > 1800)
                                          return null;
                                        else return lang == 'ru' ? 'Люди столько не живут' : 'You cant be that old';
                                      } else return lang == 'ru' ? 'Кажется, такой даты нет' : 'Incorrect date';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: lang == 'ru' ? 'День рождения':'Birthday',
                                      hintText: lang == 'ru' ? 'дд.мм.гггг' : 'dd.mm.yyyy',
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10.0),
                                      border: OutlineInputBorder(),
                                      suffixIcon: InkWell(
                                          onTap: () => showDatePicker(
                                                context: context,
                                                locale: lang == 'ru' ? Locale('ru', 'RU') : Locale('en', 'UK'),
                                                initialDatePickerMode:
                                                myDateParse(_dateController.text) != null ? DatePickerMode.day : DatePickerMode.year,
                                                initialDate: myDateParse(_dateController.text) ?? DateTime(2012),
                                                firstDate: DateTime(1950),
                                                lastDate: DateTime.now(),
                                              ).then((value) => setState(() {
                                                  if (value != null)
                                                    _dateController.text =
                                                        DateFormat('dd.MM.yyyy').format(value);
                                                  })),
                                          child: Icon(Icons.calendar_today))),
                                ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Checkbox(
                                            activeColor: Colors.lightBlue,
                                            value: licenseChecked,
                                            onChanged: (_) {
                                              setState(() {
                                                licenseChecked = !licenseChecked;
                                              });
                                            }),
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          onTap: () {
                                            launch('docs/ConsentRU.pdf');
                                          },
                                          child: Text(
                                            lang == 'ru' ?
                                            'Даю согласие на участие в исследовании' :
                                            'I agree to participate in this research',
                                            style:
                                                TextStyle(color: Colors.lightBlue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    LayoutBuilder(builder: (context, constrains) {
                                  return MaterialButton(
                                    minWidth: constrains.maxWidth,
                                    color: Colors.lightBlue,
                                    disabledColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(8))),
                                    onPressed: licenseChecked
                                        ? () {
                                      if (_formKey.currentState.validate() && genderSelected()) {
                                        username = _nameController.text;
                                        birthday = _dateController.text;
                                        gender = selected[0] ? 'M' : 'F';
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Menu()),
                                        );
                                      }
                                    }
                                        : null,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Text(
                                        lang == 'ru' ? 'Готово!' : 'Done!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }),
                            ),
                            Expanded(
                                  child: Container(
                                alignment: Alignment.bottomCenter,
                                child: languageRaw(),
                            ))
                          ]),
                              )),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget getGenderButton(text, image) {
    return Container(
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image(
              image: image,
            ),
/*              FittedBox(
                  fit: BoxFit.fitHeight,
                    child:
                    Text(text, style:
                    TextStyle(color: Colors.lightBlueAccent, fontSize: 30),))*/
          ],
        ),
      ));
  }

  Widget languageRaw() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                lang = 'ru';
                _formKey.currentState.reset();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  boxShadow: [
                    BoxShadow(
                        color: lang == 'ru' ? Colors.black26 : Colors.transparent,
                        blurRadius: 10.0,
                        offset: Offset(0, 0.0))
                  ]),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: lang == 'ru' ? 1 : 0.4,
                child: Image(
                  image: AssetImage('images/ru_flag.png'),
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: InkWell(
            onTap: () {
              setState(() {
                lang = 'en';
                _formKey.currentState.reset();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(48)),
                  boxShadow: [
                    BoxShadow(
                        color: lang == 'en' ? Colors.black26 : Colors.transparent,
                        blurRadius: 10.0,
                        offset: Offset(0, 0.0))
                  ]),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: lang == 'en' ? 1 : 0.4,
                child: Image(
                  image: AssetImage('images/uk_flag.png'),
                  width: 48,
                  height: 48,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  DateTime myDateParse(String s) {
    if (s.isEmpty)
      return null;
    s = s.trim().replaceAll('/', '.').replaceAll('-', '.').replaceAll(',', '.').replaceAll('\\', '.').replaceAll(':', '.');
    if (s.contains('.')) {
      try {
        var d =  DateFormat('dd.MM.yyyy').parseLoose(s);
        if (d.year >= 1950)
          return d;
      }
      catch (_) {}
    }
    return null;
  }

  bool genderSelected() {
    if (selected[0] || selected[1])
      return true;
    setState(() {
      shakeGender = true;
    });
    return false;
  }

}

class DateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final regEx = RegExp(r"^\d*\.?\d*");
    String newString = regEx.stringMatch(newValue.text) ?? "";
    return newString == newValue.text ? newValue : oldValue;
  }
}
