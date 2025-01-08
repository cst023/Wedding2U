import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';

class TentativeScreen extends StatefulWidget {
  final String invitationCode;

  const TentativeScreen({super.key, required this.invitationCode});

  @override
  _TentativeScreenState createState() => _TentativeScreenState();
}

class _TentativeScreenState extends State<TentativeScreen> {
  List<Map<String, String>> events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTentative();
  }

  Future<void> _fetchTentative() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch events using the controller and invitation code
      final fetchedEvents = await GuestListController()
          .fetchTentativeByInvitationCode(widget.invitationCode);

      setState(() {
        events = fetchedEvents.map<Map<String, String>>((event) {
          return {
            'id': event['id']?.toString() ?? '', // Include event ID
            'name': event['event_name']?.toString() ?? '',
            'time': event['start_time']?.toString() ?? '',
            'description': event['description']?.toString() ?? '',
          };
        }).toList();

        // Sort events by time in ascending order
        events.sort((a, b) => a['time']!.compareTo(b['time']!));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching events: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentative'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(child: Text('No events available.'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Row(
                        children: [
                          // Timeline Section
                          Column(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF222D52),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index < events.length - 1)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: const Color(0xFF222D52),
                                ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          // Event Card Section
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(event['name'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time: ${event['time'] ?? ''}'),
                                    if ((event['description'] ?? '').isNotEmpty)
                                      Text('${event['description']}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
    );
  }
}
