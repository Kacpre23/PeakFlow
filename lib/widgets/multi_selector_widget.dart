import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class MultiSelectorWidget extends StatefulWidget {
  final List<String> interests;
  final List<String> selectedInterests; // Nowa lista wybranych zainteresowań

  MultiSelectorWidget(
      {required this.interests, required this.selectedInterests});

  @override
  _MultiSelectorWidgetState createState() => _MultiSelectorWidgetState();
}

class _MultiSelectorWidgetState extends State<MultiSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: widget.interests
          .map((interest) => MultiSelectItem(interest, interest))
          .toList(),
      title: const Text("Select Interests"),
      selectedColor: Colors.orange,
      initialValue: widget
          .selectedInterests, // Ustawienie początkowo zaznaczonych zainteresowań
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      buttonIcon: const Icon(
        Icons.arrow_circle_down_sharp,
        color: Colors.white,
      ),
      buttonText: const Text(
        "Choose Interests",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      onConfirm: (values) {
        setState(() {
          widget.selectedInterests.clear(); // Wyczyszczenie starych zaznaczeń
          widget.selectedInterests
              .addAll(List<String>.from(values)); // Dodanie nowych
        });
      },
    );
  }
}
