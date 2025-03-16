import 'package:animation_example/models/category.dart';
import 'package:animation_example/models/task.dart';
import 'package:animation_example/pages/home/widgets/card_item.dart';
import 'package:animation_example/services/extentions.dart';
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

  final List<Category> categories = [
    Category(
      title: 'Work',
      tasks: [
        Task(id: '1', title: 'Meet Clients'),
        Task(id: '2', title: 'Design Sprint', isCompleted: true),
        Task(id: '3', title: 'Icon Set Design for Mobile App'),
        Task(id: '4', title: 'HTML/CSS Study'),
        Task(id: '5', title: 'Weekly Report'),
        Task(id: '6', title: 'Design Meeting'),
        Task(id: '7', title: 'Quick Prototyping'),
      ],
    ),
    Category(
      title: 'Home',
      tasks: [
        Task(id: '1', title: 'Meet Clients'),
        Task(id: '2', title: 'Design Sprint', isCompleted: true),
        Task(id: '3', title: 'Icon Set Design for Mobile App'),
        Task(id: '4', title: 'HTML/CSS Study'),
      ],
    ),
    Category(
      title: 'Personal',
      tasks: [
        Task(id: '1', title: 'Meet Clients'),
        Task(id: '2', title: 'Design Sprint', isCompleted: true),
        Task(id: '3', title: 'Icon Set Design for Mobile App'),
        Task(id: '4', title: 'HTML/CSS Study'),
        Task(id: '5', title: 'Weekly Report'),
        Task(id: '6', title: 'Design Meeting'),
      ],
    ),
    Category(
      title: 'Personal',
      tasks: [
        Task(id: '4', title: 'HTML/CSS Study'),
        Task(id: '5', title: 'Weekly Report'),
        Task(id: '6', title: 'Design Meeting'),
      ],
    ),
    Category(title: 'Personal', tasks: [Task(id: '1', title: 'Meet Clients')]),
    Category(
      title: 'Personal',
      tasks: [
        Task(id: '1', title: 'Meet Clients'),
        Task(id: '2', title: 'Design Sprint', isCompleted: true),
        Task(id: '3', title: 'Icon Set Design for Mobile App'),
        Task(id: '4', title: 'HTML/CSS Study'),
        Task(id: '5', title: 'Weekly Report'),
        Task(id: '6', title: 'Design Meeting'),
      ],
    ),
  ];

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
                        tasks: categories[index].tasks,
                        index: index,
                        title: categories[index].title,
                        progress: categories[index].tasks.completedPercentage,
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
