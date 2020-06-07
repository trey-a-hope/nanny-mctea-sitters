import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money/money.dart';

abstract class IFormatterService {
  String money({@required int amount});
}

class FormatterService extends IFormatterService {
  @override
  String money({@required int amount}) {
    final money = Money(amount, Currency('USD'));
    return '\$${money.amountAsString}';
  }
}
