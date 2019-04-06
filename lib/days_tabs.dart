import 'package:flutter/material.dart';

class DaysTabs extends StatefulWidget {
  final int _dayInput;
  final List<Map<String, Object>> days;
  final Function(Map<String, Object>) callback;
  DaysTabs(this.days, this._dayInput, this.callback);
  @override
  _DaysTabsState createState() => _DaysTabsState();
}

class _DaysTabsState extends State<DaysTabs> {
  // Create a tab controller
  TabController controller;

  @override
  void initState() {
    super.initState();
  }

  _buildButton(Map day) {
    Color color =
        day['id'] == widget._dayInput ? Colors.purple : Colors.black54;
    return FlatButton(
        color: color,
        child: Text('${day['name']}'),
        onPressed: () {
          widget.callback(day);
        });
  }

  @override
  Widget build(BuildContext contex) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rutinas',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('#Dias',
            style:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 25)),
        Column(
            children:
                widget.days.map<Widget>((day) => _buildButton(day)).toList())
      ],
    ));
  }
}

// SingleTickerProviderStateMixin is used for animation SOLO TABS
/* class _DaysTabsState extends State<DaysTabs>
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
} */
