import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? height;
  double? width;

  String a = '';
  double x = 0;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // height = 0.25 * MediaQuery.of(context).size.height;
    // width = 0.25 * MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 0.35 * MediaQuery.of(context).size.height,
                child: TextField(
                  readOnly: true,
                  showCursor: true,
                  controller: _controller,
                  cursorColor: Colors.orange,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowFirst!,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowOne!,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowTwo!,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowThree!,
              ),
            ),
            Expanded(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: rowFour!,
              ),
            ),

            // Expanded(
            //   child: Row(
            //     // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: rowFive!,
            //   ),

            // ),
          ],
        ),
      ),
    );
  }

  void displayCalculation(String newInput) {
    if (newInput == '=') {
      newInput = solveForx(_controller.text);
      return setState(() {
        _controller.text = newInput;
      });
    }
    setState(() {
      final text = _controller.text;
      final newText;
      final txtLength = text.length - 2 < 0 ? 0 : text.length - 2; /// possible last operand position
      final TextSelection textSelection = _controller.selection;
      final cursorLength = textSelection.end;

      String regExp = '^[+-\u00f7\u00d7]';
      if(text.isNotEmpty && text[txtLength].contains(RegExp(r'^[+-\u00f7\u00d7]')) && newInput.contains(RegExp(r'^[+-\u00f7\u00d7]')) && cursorLength == text.length) {
        newText = text.replaceRange(text.length-1, text.length, newInput);

      } else {
        newText = text.replaceRange(
            textSelection.start == -1 ? 0 : textSelection.start,
            textSelection.end == -1 ? 0 : textSelection.end,
            newInput);
      }
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    });
  }

  String solveForx(String ss) {
    int index = 0;
    List<String> asss = ss.split(RegExp('\\s'));
    for (int i = 0; i < asss.length; i++) {
      asss[i] = percentageOf(asss[i]);
      if (asss[i] == '\u00d7') {
        String lhs = asss[i - 1];
        String rhs = asss[i + 1];
        String ans = (double.parse(lhs) * double.parse(rhs)).toString();
        asss[i] = ans;
        asss.removeAt(i - 1);
        asss.removeAt(i);
        i = i - 1;
      }
      if (asss[i] == '\u00f7') {
        String lhs = asss[i - 1];
        String rhs = asss[i + 1];
        String ans = (double.parse(lhs) / double.parse(rhs)).toString();
        asss[i] = ans;
        asss.removeAt(i - 1);
        asss.removeAt(i);
        i = i - 1;
      }
    }
    if (asss.length == 1) return asss[0];
    int operand = 1;
    double x = double.parse(asss[0]);
    index = 2;
    for (int i = 0; index < asss.length; i++) {
      String operation = asss[operand];

      switch (operation) {
        case '+':
          x = x + double.parse(asss[index]);
          break;
        case '-':
          x = x - double.parse(asss[index]);
          break;
      }
      operand = operand + 2;
      index = index + 2;
    }
    return x.toString();
  }
  String percentageOf(String x) {
    if(x.endsWith('%')){
      x = x.substring(0, x.length-1);
      x = (double.parse(x) / 100).toString();
    }
    return x;
  }

  List<Widget>? rowOne, rowTwo, rowThree, rowFour, rowFirst;

  @override
  void initState() {
    createCalcRows();
    super.initState();
  }

  void createCalcRows() {
    String btnValue;
    rowThree = List.generate(4, (index) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (index == 3)
              btnValue = ' + ';
            else
              btnValue = (index + 1).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? ' + ' : null,
            index: index,
            height: 50,
            width: 50,
            color: index == 3 ? Color(0xfff6962b) : null,
          ),
        ),
      );
    });

    rowTwo = List.generate(4, (index) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (index == 3)
              btnValue = ' \u00d7 ';
            else
              btnValue = (index + 4).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? '\u00d7' : null,
            index: index + 3,
            height: 50,
            width: 50,
            color: index == 3 ? Color(0xfff6962b) : null,
          ),
        ),
      );
    });
    rowOne = List.generate(4, (index) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (index == 3)
              btnValue = ' \u00f7 ';
            else
              btnValue = (index + 7).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? '\u00f7' : null,
            index: index + 6,
            height: 50,
            width: 50,
            color: index == 3 ? Color(0xfff6962b) : null,
          ),
        ),
      );
    });

    rowFour = List.generate(3, (index) {
      String btnVal = '';
      if (index == 1)
        btnVal = '.';
      else if (index == 2) btnVal = '=';
      return Expanded(
        flex: index == 0 ? 2 : 1,
        child: GestureDetector(
          onTap: () {
            if (index == 0) btnVal = '0';
            displayCalculation(btnVal);
          },
          child: CalcButton(
            btnVal: index != 0 ? btnVal : null,
            index: index - 1,
            height: 50,
            width: 50,
            color: index == 2 ? Color(0xfff6962b) : null,
            makeCircular: index == 0 ? false : true,
          ),
        ),
      );
    });
    rowFirst = List.generate(4, (index) {
      String btnVal = '';
      if (index == 0)
        btnVal = 'DEL';
      else if (index == 1)
        btnVal = '+/-';
      else if (index == 2)
        btnVal = '%';
      else if (index == 3) btnVal = ' - ';

      return Expanded(
        child: GestureDetector(
          onTap: () {
            displayCalculation(btnVal);
          },
          child: CalcButton(
            btnVal: btnVal,
            index: index - 1,
            height: 50,
            width: 50,
            color: index == 3 ? Color(0xfff6962b) : Colors.blueGrey,
          ),
        ),
      );
    });
  }
}

class CalcButton extends StatelessWidget {
  final int? index;
  final double? height;
  final double? width;
  final Color? color;
  final String? btnVal;
  final bool makeCircular;

  CalcButton(
      {Key? key,
        this.index,
        this.height,
        this.width,
        this.color = const Color(0xffbdbdbd),
        this.btnVal,
        this.makeCircular = true,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      width: makeCircular ? 75.0 : 145,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 0.00, blurRadius: 1.8)],
        border: Border.all(color: Colors.white, width: 0.5),
        borderRadius: makeCircular ? null : BorderRadius.circular(80.0),
        shape: makeCircular ? BoxShape.circle : BoxShape.rectangle,
        color: color ?? Color(0xffbdbdbd),
        // border: Border.all(width: 0.2, color: Colors.white),
      ),
      child: Text(
        btnVal ?? (index! + 1).toString(),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }
}
