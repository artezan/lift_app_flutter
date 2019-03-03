import 'package:flutter/material.dart';

class DaysTabs extends StatefulWidget {
  final int _dayInput;
  final List<Map<String, Object>> days;
  final Function(Map<String, Object>) callback;
  DaysTabs(this.days, this._dayInput, this.callback);
  @override
  _DaysTabsState createState() => _DaysTabsState();
}

// SingleTickerProviderStateMixin is used for animation
class _DaysTabsState extends State<DaysTabs>
    with SingleTickerProviderStateMixin {
  // Create a tab controller
  TabController controller;

  @override
  void initState() {
    super.initState();
    // Initialize the Tab Controller
    controller = new TabController(
        length: widget.days.length,
        vsync: this,
        initialIndex: widget._dayInput);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contex) {
    return new TabBar(
      // map tiene que tener toList
      tabs: widget.days.map((day) => Tab(text: day['name'])).toList(),
      controller: controller,
      onTap: (n) {
        var day = widget.days.singleWhere((d) => d['id'] == n);
        widget.callback(day);
      },
    );
  }
}
