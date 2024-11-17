import 'package:flutter/material.dart';
import '../widgets/event_list.dart';
import '../models/event.dart';
import '../screens/add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> events = [];
  bool showUpcoming = true;

  void addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }

  void _deleteEvent(int index) {
    setState(() {
      events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.orange.shade200,
          centerTitle: false,
          title:const Padding(
            padding:  EdgeInsets.only(top: 20.0, left: 10.0),
            child:  Text(
              'Calendar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 32.0,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
                onPressed: () async {
                  final event = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEventScreen()),
                  );
                  if (event != null) {
                    setState(() => events.add(event));
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.orange.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Upcoming', showUpcoming, () {
                  setState(() => showUpcoming = true);
                }),
                _buildFilterButton('Past', !showUpcoming, () {
                  setState(() => showUpcoming = false);
                }),
              ],
            ),
          ),
          Expanded(
            child: EventList(
              events: events,
              onDelete: _deleteEvent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isActive, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.orange : Colors.orange.shade200,
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}