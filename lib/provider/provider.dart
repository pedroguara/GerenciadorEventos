import 'package:flutter/material.dart';
import 'package:gerenciador_eventos/main.dart';
import 'package:intl/intl.dart';


class EventProvider with ChangeNotifier {
  List<Event> _eventList = [];
  List<Event> _filteredEventList = [];
  String _sortOrder = 'asc';
  int _selectedIndex = 0;

  List<Event> get eventList => _eventList;
  List<Event> get filteredEventList => _filteredEventList;
  String get sortOrder => _sortOrder;
  int get selectedIndex => _selectedIndex;

  TextEditingController searchController = TextEditingController();

  EventProvider() {
    _filteredEventList = _eventList;
    searchController.addListener(_filterEvents);
  }

  void addEvent(Event newEvent) {
    _eventList.add(newEvent);
    _filterEvents();
    _selectedIndex = 0;
    notifyListeners();
  }

  void editEvent(Event updatedEvent, int index) {
    _eventList[index] = updatedEvent;
    _filterEvents();
    notifyListeners();
  }

  void deleteEvent(int index) {
    _eventList.removeAt(index);
    _filterEvents();
    notifyListeners();
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
    notifyListeners();
  }

  void changeSortOrder(String value) {
    _sortOrder = value;
    _sortEvents();
    notifyListeners();
  }

  void changeSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
