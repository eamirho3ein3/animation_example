import 'package:animation_example/pages/home/widgets/card_item.dart';
import 'package:flutter/material.dart';

final List<Color> backgroundColors = [
  Colors.blue,
  Colors.orange,
  Colors.green,
  Colors.purple,
  Colors.red,
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.7);

  int _currentIndex = 0;
  Color _backgroundColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int newIndex = _pageController.page!.round();
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
          _animateBackgroundColor(backgroundColors[newIndex]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      color: _backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 5),
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    // Hi message
                    Text(
                      'Hi there!',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Date
              Padding(
                padding: const EdgeInsets.fromLTRB(60.0, 16.0, 16.0, 8.0),
                child: Text(
                  'TODAY: MARCH 13, 2025',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),

              // Cards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: PageView.builder(
                    clipBehavior: Clip.none,
                    controller: _pageController,
                    itemCount: backgroundColors.length,
                    itemBuilder: (context, index) {
                      return CardItem(
                        index: index,
                        title:
                            index == 0
                                ? 'Work'
                                : (index == 1 ? 'Home' : 'Personal'),
                        taskCount: index == 0 ? 12 : (index == 1 ? 7 : 5),
                        progress:
                            index == 0 ? 0.24 : (index == 1 ? 0.45 : 0.15),
                        isSelected: _currentIndex == index,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _animateBackgroundColor(Color newColor) {
    setState(() {
      _backgroundColor = newColor;
    });
  }
}
