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
    CupertinoIcons.money_euro,
    CupertinoIcons.money_dollar,
    CupertinoIcons.money_pound,
  ];

  String getCurrency(symbol) {
    return currencies[symbols.indexOf(symbol)];
  }

  String getSymbol(currency) {
    return symbols[currencies.indexOf(currency)];
  }
}