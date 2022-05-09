import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bricolage_app/constants.dart';

import '../../size_config.dart';

class FilterScreen extends StatelessWidget {

  List<String>selectedcategories=List.empty();
  List<filterChipWidget> chips =List.empty();
  late RangeValues currentRangeValues;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Filter",style: TextStyle(fontSize: 18)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: getProportionateScreenHeight(40)),
      const Text("Select Price Range",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
      SizedBox(height: getProportionateScreenHeight(30)),
      PriceSlider(),
      SizedBox(height: getProportionateScreenHeight(30)),
      const Text("Select Categories",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
      SizedBox(height: getProportionateScreenHeight(30)),
      Wrap(
        spacing: 5.0,
        runSpacing: 3.0,
        children: chips =kcategories.map((category) => filterChipWidget(
          chipName: category,
        )).toList(),
      ),
      SizedBox(height: getProportionateScreenHeight(100)),
      Center(
        child: ElevatedButton(
          style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(kColor)),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 27),
            child: Text("Apply",style: TextStyle(fontSize: 18)),
          ),
          onPressed: () {
              selectedcategories=chips.where((element) => element._isSelected==true).map((e) => e.chipName).toList();
              Navigator.pop(context,[selectedcategories,PriceSlider._currentRangeValues]);
          }
    ),
    ),
    ]
    )
    ),
    );
  }
}
class PriceSlider extends StatefulWidget {
  static RangeValues _currentRangeValues = const RangeValues(40, 500);
   PriceSlider({Key? key}) : super(key: key);

  @override
  _PriceSliderState createState() => _PriceSliderState();
}

class _PriceSliderState extends State<PriceSlider> {
  @override
  Widget build(BuildContext context) {
    final darkMode = Theme.of(context).brightness==Brightness.dark;
    return RangeSlider(
    values: PriceSlider._currentRangeValues,
    max: 5000,
    divisions: 2500,
    inactiveColor: darkMode?null:kColor,
    activeColor: darkMode?null:kOrangeColor,
    labels: RangeLabels(
    PriceSlider._currentRangeValues.start.round().toString(),
    PriceSlider._currentRangeValues.end.round().toString(),
    ),
    onChanged: (RangeValues values) {
    setState(() {
      PriceSlider._currentRangeValues = values;
    });
    },
    );
  }
}


class filterChipWidget extends StatefulWidget {
  final String chipName;
  bool _isSelected=false;

  filterChipWidget({Key? key, required this.chipName}) : super(key: key);

  @override
  _filterChipWidgetState createState() => _filterChipWidgetState();
}

class _filterChipWidgetState extends State<filterChipWidget> {

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
      label: Text(widget.chipName),
      labelStyle: const TextStyle(color: Color(0xff6200ee),fontSize: 18.0,fontWeight: FontWeight.bold),
      selected: widget._isSelected,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            30.0),),
      backgroundColor: Color(0xffededed),
      onSelected: (isSelected) {
        setState(() {
          widget._isSelected = isSelected;
        });
      },
      selectedColor: Color(0xffeadffd),);
  }
}
