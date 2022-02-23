import 'dart:collection';

class Calculator {
  static String calculate(String ss) {
    int index = 0;
    double v = 0.0;
    String matchOne = '(?<=\\))|(?=\\))';
    String matchTwo = '(?<=\\()|(?=\\()';
    String matchThree = '(?<=\\+)|(?=\\+)';
    String matchFour = '(?<=\\-)|(?=\\-)';
    String matchFive = '(?<=\\*)|(?=\\*)';
    String matchSix = '(?<=\\/)|(?=\\/)';

    List<String> asss = ss.split(RegExp('($matchOne|$matchTwo|$matchThree|$matchFour|$matchFive|$matchSix)'));
    Queue<double> values = Queue();
    Queue<String> ops = Queue();
    while (index <= asss.length - 1) {
      asss[index] = asss[index].trim();
      if (asss[index] == '(') {
      } else if (asss[index] == '+')
        ops.addFirst(asss[index]);
      else if (asss[index] == '-')
        ops.addFirst(asss[index]);
      else if (asss[index] == '*')
        ops.addFirst(asss[index]);
      else if (asss[index] == '/')
        ops.addFirst(asss[index]);
      else if (asss[index] == ')') {
        if (values.isNotEmpty && ops.isNotEmpty) {
          v = values.removeFirst();
          String op = ops.removeFirst();
          if (op == '+')
            v = values.removeFirst() + v;
          else if (op == '-')
            v = values.removeFirst() - v;
          else if (op == '*')
            v = values.removeFirst() * v;
          else if (op == '/') v = values.removeFirst() / v;
          values.addFirst(v);
        }
      } else {
        if (asss[index].length > 1 && asss[index][asss[index].length - 1] == '%') {
          var x = asss[index].split('%');
          v = double.parse(x[0]);
          v = v / 100;
          values.addFirst(v);
        } else
          values.addFirst(double.parse(asss[index]));
      }
      index++;
    }
    doComputation(values, ops, v);
    return values.removeFirst().toString();
  }

  static void doComputation(Queue<double> values, Queue<String> ops, double v) {
    while (values.length > 1 && ops.isNotEmpty) {
      v = values.removeFirst();
      String op = ops.removeFirst();
      if (op == '+')
        v = values.removeFirst() + v;
      else if (op == '-')
        v = values.removeFirst() - v;
      else if (op == '*')
        v = values.removeFirst() * v;
      else if (op == '/') v = values.removeFirst() / v;
      values.addFirst(v);
    }
  }
  }
void alternativeComputation(Queue<double> values, Queue<String> ops, double v) {
  String operation = '';
  while (ops.isNotEmpty) {
    if (ops.removeFirst() == '+') {
      operation = '+ ${values.removeFirst()} +';
    } else if (ops.removeFirst() == '*') {
      operation =
      '$operation ( ${values.removeFirst()} * ${values.removeFirst()} )';
    }
  }
}
