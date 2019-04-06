import 'package:flutter/material.dart';
import 'package:lift_app/card_details.dart';
import 'package:lift_app/cards.dart';
import 'package:lift_app/days_tabs.dart';

class RutineCards extends StatefulWidget {
  final blocks;
  final days;
  final currentDay;
  final currentPage;
  final callbackPage;
  final callbackDay;

  RutineCards(this.blocks, this.days, this.currentDay, this.currentPage,
      this.callbackPage, this.callbackDay);
  @override
  _RutineCardsState createState() => _RutineCardsState();
}

class _RutineCardsState extends State<RutineCards> {
  // Crea controller
  PageController ctrl;

  @override
  void initState() {
    super.initState();
    // Initialize the  Controller
    ctrl = PageController(
        viewportFraction: 0.8, keepPage: true, initialPage: widget.currentPage);
    // Set state when page changes
  }

  @override
  void dispose() {
    // Dispose of the  Controller
    ctrl.dispose();
    super.dispose();
  }

  Widget _buildCard(block, Map<dynamic, double> settings, currentIdx) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(
            top: settings['top'], bottom: settings['bottom'], right: 30),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
              color: Color.fromARGB(settings['color'].round(), 0, 0, 0),
              offset: Offset(settings['offsetX'], settings['offsetY']),
              blurRadius: settings['blur'],
              spreadRadius: -3)
        ]),
        child: GestureDetector(
            onDoubleTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CardDetail(block, currentIdx)),
                // MaterialPageRoute(builder: (context) => _selectedCard(block)),
              );
            },
            child: Hero(
              tag: "heroTag1$currentIdx",
              child: Container(
                child: Cards(block),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        onPageChanged: (n) => widget.callbackPage(n),
        controller: ctrl,
        itemCount: widget.blocks.length + 1,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == 0) {
            return DaysTabs(widget.days, widget.currentDay, widget.callbackDay);
          } else if (widget.blocks.length >= currentIdx) {
            // Active page
            bool isActive = currentIdx == widget.currentPage;
            // Animated Properties
            Map<String, double> settings = {
              'blur': isActive ? 7 : 1,
              'offsetX': isActive ? 9 : 0,
              'offsetY': isActive ? 17 : 3,
              'top': isActive ? 25 : 100,
              'bottom': isActive ? 25 : 100,
              'color': isActive ? 50 : 0
            };
            return _buildCard(
                widget.blocks[currentIdx - 1], settings, currentIdx);
          }
        });
  }
}
