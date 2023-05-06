import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/components/akahu_auth_widget.dart';
import 'package:silverspy/providers/auth_provider.dart';

import '../components/full_width_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedFrequency = 'Monthly';
  DateTime _selectedDate = DateTime.now();

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       'Income Settings',
                //       style: Theme.of(context).textTheme.titleMedium,
                //     ),
                //     SizedBox(height: 8.0),
                //     DropdownButton<String>(
                //       value: _selectedFrequency,
                //       onChanged: (String? value) {
                //         setState(() {
                //           _selectedFrequency = value!;
                //         });
                //       },
                //       items: <String>['Weekly', 'Fortnightly', 'Monthly']
                //           .map<DropdownMenuItem<String>>((String value) {
                //         return DropdownMenuItem<String>(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //     ),
                //     SizedBox(height: 16.0),
                //     Text(
                //       'Income date',
                //       style: Theme.of(context).textTheme.subtitle1,
                //     ),
                //     SizedBox(height: 8.0),
                //     InkWell(
                //       onTap: _showDatePicker,
                //       child: Row(
                //         children: [
                //           Icon(Icons.calendar_today),
                //           SizedBox(width: 8.0),
                //           Text(
                //             '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                //             style: Theme.of(context).textTheme.bodyMedium,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // SizedBox(height: 32,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Akahu Settings',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.0),
                    AkahuAuthWidget(),
                  ],
                )
              ],
            ),
            FullWidthButton(
                label: "Log out",
                onPressed: () {
                  authProvider.logout();
                })
          ],
        ),
      ),
    );
  }
}
