import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:task_02_category_widget/unit.dart';

const _padding = EdgeInsets.all(16.0);

class ConverterRoute extends StatefulWidget {

  final Color color;

  final List<Unit> units;

  const ConverterRoute({
    @required this.color,
    @required this.units,
  }) : assert(color != null),
       assert(units != null);

       @override
       _ConverterRouteState createState() => _ConverterRouteState();

}

class _ConverterRouteState extends State<ConverterRoute> {
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List<DropdownMenuItem>  _unitMenuItems;
  bool _showValidationError = false;

  @override
  void initState() {
    super.initState();
    _createDropDownMenuItems();
    _setDefaults();
  }

  void _createDropDownMenuItems(){
    var newItems = <DropdownMenuItem>[];
    for (var unit in widget.units) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            softWrap: true,
          ),
        ),
      ));
    }
    setState(() {
      _unitMenuItems = newItems;
    });
    
  }

  ///Sets the default values for the 'from' and 'to' [Dropdown]s.
  void _setDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
  });
  }
  //Clean up conversion.
  String __format(double conversion) {
      var outputNum = conversion.toStringAsPrecision(7);
      if (outputNum.contains('.') && outputNum.endsWith('0')) {
        var i = outputNum.length - 1;
        // ignore: unrelated_type_equality_checks
        while (outputNum[i] == 0) {
          i -= 1;
        }
        outputNum = outputNum.substring(0, i + 1);
      }
      if(outputNum.endsWith('.')) {
        return outputNum.substring(0, outputNum.length - 1);
      }
      return outputNum;
      }

      void _updateConversion() {
        setState(() {
          _convertedValue = 
          __format(_inputValue * (_toValue.conversion / 
          _fromValue.conversion));
        });
      }

       void _updateInputValue(String input) {
         setState(() {
           if (input == null || input.isEmpty) {
             _convertedValue = '';
           } else {
             try {
               final inputDouble = double.parse(input);
               _showValidationError = false;
               _inputValue = inputDouble;
               _updateConversion();
             } on Exception catch (e) {
               print('Error: $e');
               _showValidationError = true;
             }
           }
         });
       } 

       Unit _getUnit(String unitName) {
         return widget.units.firstWhere(
           (Unit unit) {
             return unit.name == unitName;
           },
           orElse: null,
         );
       }
      
      void _updateFromConversion(dynamic unitName) {
        setState(() {
          _fromValue = _getUnit(unitName);
        });
        if (_inputValue != null) {
          _updateConversion();
        }
      }

  void _updateToConversion(dynamic unitName) {
        setState(() {
          _toValue = _getUnit(unitName);
        });
        if (_inputValue != null) {
          _updateConversion();
        }
      }

      Widget _createDropDown(String currentValue, ValueChanged<dynamic> onChanged) {
        return Container(
          margin: EdgeInsets.only(top: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(
              color: Colors.grey[400],
              width: 1.0,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Theme(
            //This sets the color of the [DropDownMenuItem]
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[50],
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  value: currentValue,
                  items: _unitMenuItems,
                  onChanged: onChanged,
                  style: Theme.of(context).textTheme.headline6,
              ),
              ),

          ),

        ),
        );

      }

 
  @override
  Widget build(BuildContext context) {
    final input = Padding(
     padding: _padding,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
                   // This is the widget that accepts text input. In this case, it
          // accepts numbers and calls the onChanged property on update.
      TextField(
        style: Theme.of(context).textTheme.headline4,
        decoration: InputDecoration(
          labelStyle: Theme.of(context).textTheme.headline6,
          errorText: _showValidationError ? 'Invalid number entered' : null,
          labelText: 'Input',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0.0),
        ),

      ),
      keyboardType: TextInputType.number,
      onChanged: _updateInputValue,
      ),
      _createDropDown(_fromValue.name,_updateFromConversion),
 ],
     ),
    );

    final arrows = RotatedBox(
      quarterTurns: 1,
      child:Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

  final output = Padding(
    padding: _padding,
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InputDecorator(
            child: Text(
              _convertedValue,
              style: Theme.of(context).textTheme.headline6,
            ),
            decoration: InputDecoration(
              labelText: 'Output',
              labelStyle: Theme.of(context).textTheme.headline6,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
          ),
          _createDropDown(_toValue.name, _updateToConversion),
        ],
      ),
    );

    final converter = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        input,
        arrows,
        output,
      ],
    );

    return Padding(
      padding: _padding,
      child: converter,
    );
  }
}