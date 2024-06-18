import 'package:flutter/material.dart';
import 'package:gerenciador_eventos/main.dart';
import 'package:gerenciador_eventos/provider/provider.dart';


class EventController {
  final EventProvider _provider;

  EventController(this._provider);

  Future<void> addEvent(BuildContext context) async {
    final newEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventPage(),
      ),
    );
    if (newEvent != null) {
      _provider.addEvent(newEvent);
    }
  }

  Future<void> editEvent(BuildContext context, Event event, int index) async {
    final updatedEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: event),
      ),
    );
    if (updatedEvent != null) {
      _provider.editEvent(updatedEvent, index);
    }
  }

  void deleteEvent(int index) {
    _provider.deleteEvent(index);
  }
}
