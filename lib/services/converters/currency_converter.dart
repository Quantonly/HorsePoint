import 'package:flutter/cupertino.dart';

class CurrencyConverter {
  final List<String> fullNames = [
    'Euro',
    'Dollar',
    'Pound'
  ];

  final List<String> currencies = [
    'EUR',
    'USD',
    'GBP'
  ];

  final List<String> symbols = [
    '€',
    '\$',
    '£'
  ];

  final List<IconData> icons = [
    CupertinoIcons.money_euro_circle,
    CupertinoIcons.money_dollar_circle,
    CupertinoIcons.money_pound_circle,
  ];

  String getCurrency(symbol) {
    return currencies[symbols.indexOf(symbol)];
  }

  String getSymbol(currency) {
    return symbols[currencies.indexOf(currency)];
  }
}