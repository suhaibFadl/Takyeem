import 'package:flutter/material.dart';

class TakyeemDropDownButton extends StatefulWidget {
  TakyeemDropDownButton({super.key, required this.items, this.value});

  final List<DropdownMenuItem<String>> items;
  String? value;

  @override
  State<TakyeemDropDownButton> createState() => _TakyeemDropDownButtonState();
}

class _TakyeemDropDownButtonState extends State<TakyeemDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // dropdownColor: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      itemHeight: 65,
      underline: const SizedBox(),
      iconSize: 45,
      // borderRadius: BorderRadius.circular(10),
      hint: Text(
        "نـــــوع  \nالتسميع",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 25),
        textDirection: TextDirection.rtl,
        // textAlign: TextAlign.start,
      ),
      value: widget.value,
      items: widget.items,
      onChanged: (value) {
        setState(() {
          widget.value = value;
        });
      },
    );
  }
}
