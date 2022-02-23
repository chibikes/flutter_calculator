import 'package:flutter_calculator/calculator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple Calculator'),
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


          ],
        ),
      ),
    );
  }

  void displayCalculation(String newInput) {

    final cursorLength = _controller.selection.end;
    if (newInput == '=') {
      try {
        newInput = Calculator.calculate(_controller.text);
      }catch (e) {
        newInput = '0';
      }
      return setState(() {
        _controller.text = newInput;
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      });
    } else if(newInput == 'DEL/AC') {
      //TODO: you must press DEL twice instead of once to be able to delete. shouldn't be so.
      return setState(() {
        _controller.text.isNotEmpty ?
        _controller.text = _controller.text.replaceRange(cursorLength-1, cursorLength, '')
            : _controller.text;
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: cursorLength - 1));
      });

    }
    else if(newInput == 'AC') {
      return setState((){
        _controller.text.isNotEmpty ? _controller.text = '' : _controller.text;
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      });
    }
    setState(() {
      final text = _controller.text;
      final newText;
      final txtLength = text.length - 2 < 0 ? 0 : text.length - 2; /// possible last operand position
      final TextSelection textSelection = _controller.selection;


      newText = text.replaceRange(
          textSelection.start == -1 ? 0 : textSelection.start,
          textSelection.end == -1 ? 0 : textSelection.end,
          newInput);
      _controller.text = newText;
      _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    });
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
              btnValue = '+';
            else
              btnValue = (index + 1).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? '+' : null,
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
              btnValue = '*';
            else
              btnValue = (index + 4).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? '*' : null,
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
              btnValue = '/';
            else
              btnValue = (index + 7).toString();
            displayCalculation(btnValue);
          },
          child: CalcButton(
            btnVal: index == 3 ? '/' : null,
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
        btnVal = 'DEL/AC';
      else if (index == 1)
        btnVal = '(';
      else if (index == 2)
        btnVal = ')';
      else if (index == 3) btnVal = '-';

      return Expanded(
        child: GestureDetector(
          onLongPressUp: () {
            if(btnVal == 'DEL/AC')
              displayCalculation('AC');
          },
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
