import 'package:flutter/material.dart';
import 'Dynamic_duty.dart';
import 'Static_duty.dart';

class Assigning_duty extends StatefulWidget {
  @override
  State<Assigning_duty> createState() => _Assigning_dutyState();
}

class _Assigning_dutyState extends State<Assigning_duty> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assigning Duties'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Static Duty'),
              Tab(text: 'Dynamic Duty'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Static_duty(),
            Dynamic_duty(),
          ],
        ),
      ),
    );
  }
}
