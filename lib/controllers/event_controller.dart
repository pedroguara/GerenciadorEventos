import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';

class EventController extends ChangeNotifier {
  final List<Event> _eventList = [];
  List<Event> _filteredEventList = [];
  final TextEditingController searchController = TextEditingController();
  String _sortOrder = 'asc';

  List<Event> get eventList => _filteredEventList;
  String get sortOrder => _sortOrder; // Adicionando o getter para _sortOrder

  EventController() {
    _filteredEventList = _eventList;
    searchController.addListener(_filterEvents);
  }

  void addEvent(Event event) {
    _eventList.add(event);
    _filterEvents();
  }

  void updateEvent(int index, Event event) {
    _eventList[index] = event;
    _filterEvents();
  }

  void removeEvent(int index) {
    _eventList.removeAt(index);
    _filterEvents();
  }

  void setSortOrder(String sortOrder) {
    _sortOrder = sortOrder;
    _sortEvents();
  }

  void _filterEvents() {
    final query = searchController.text.toLowerCase();
    _filteredEventList = _eventList.where((event) {
      return event.name.toLowerCase().contains(query) ||
          event.address.toLowerCase().contains(query) ||
          event.contractor.toLowerCase().contains(query) ||
          event.classification.toLowerCase().contains(query) ||
          event.ticketsSold.toString().contains(query) ||
          DateFormat.yMMMd().format(event.date).toLowerCase().contains(query);
    }).toList();
    _sortEvents();
    notifyListeners();
  }

  void _sortEvents() {
    _filteredEventList.sort((a, b) {
      if (_sortOrder == 'asc') {
        return a.date.compareTo(b.date);
      } else {
        return b.date.compareTo(a.date);
      }
    });
  }
}
