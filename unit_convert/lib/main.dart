import 'package:flutter/material.dart';
import 'package:unit_convert/screens/temperature_converter_screen.dart';
import 'package:unit_convert/screens/weight_converter_screen.dart';
import 'screens/length_converter_screen.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget
{
  @override
  Widget build(BuildContext ctx)
  {
    return MaterialApp
    (
        title: 'Unit Converter',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: WeightConverterScreen(),
    );
  }
}