import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:task_02_category_widget/unit.dart';

class ConverterRoute extends StatelessWidget {

  final Color color;

  final List<Unit> units;

  const ConverterRoute({
    @required this.color,
    @required this.units,
  }) : assert(color != null),
       assert(units != null);

  @override
  Widget build(BuildContext context) {
    final unitWidgets = units.map((Unit unit) {
      return Container(
        color: color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
          ),
          );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }
  
}