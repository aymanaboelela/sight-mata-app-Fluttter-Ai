import 'package:flutter/material.dart';

class Usertype extends StatefulWidget {
  const Usertype({super.key, required this.isAdmin});
  final Function(bool) isAdmin;
  @override
  State<Usertype> createState() => _UsertypeState();
}

class _UsertypeState extends State<Usertype> {
  List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return  ToggleButtons(
      children:  [
       const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Visually Impaired',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: Text(
            'Fellow',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      isSelected: _isSelected,
      onPressed: (index) {
        setState(() {
          for (int i = 0; i < _isSelected.length; i++) {
            _isSelected[i] = (i == index);
            widget.isAdmin(_isSelected[i]);
          }
        });
      },
      // Optional styling
      borderRadius: BorderRadius.circular(30),
      selectedColor: Colors.white, // selected Text color
      fillColor: const Color.fromARGB(255, 120, 98, 146),
      color: Colors.black, //  unselected Text color
    );
  }
}
