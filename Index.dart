import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Color(0xFF202020),
      appBarTheme: AppBarTheme(
        color: Color(0xFF202020),
        titleTextStyle: TextStyle(color: Color(0xFFE6285A), fontSize: 20),
        iconTheme: IconThemeData(color: Color(0xFFE6285A)),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFE6285A),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE6285A)),
        ),
      ),
      iconTheme: IconThemeData(color: Color(0xFFE6285A)),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Event> _eventList = [];
  List<Event> _filteredEventList = [];
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'asc';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _filteredEventList = _eventList;
    _searchController.addListener(_filterEvents);
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEventList = _eventList.where((event) {
        return event.name.toLowerCase().contains(query) ||
            event.address.toLowerCase().contains(query) ||
            event.contractor.toLowerCase().contains(query) ||
            event.classification.toLowerCase().contains(query) ||
            event.ticketsSold.toString().contains(query) ||
            DateFormat.yMMMd().format(event.date).toLowerCase().contains(query);
      }).toList();
      _sortEvents();
    });
  }

  void _sortEvents() {
    setState(() {
      _filteredEventList.sort((a, b) {
        if (_sortOrder == 'asc') {
          return a.date.compareTo(b.date);
        } else {
          return b.date.compareTo(a.date);
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _navigateToAddEventPage() async {
    final newEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventPage(),
      ),
    );
    if (newEvent != null) {
      setState(() {
        _eventList.add(newEvent);
        _filterEvents();
        _selectedIndex = 0;
      });
    }
  }

  Future<void> _navigateToEditEventPage(Event event, int index) async {
    final updatedEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventPage(event: event),
      ),
    );
    if (updatedEvent != null) {
      setState(() {
        _eventList[index] = updatedEvent;
        _filterEvents();
      });
    }
  }

  List<Widget> _pages() => [
        EventListPage(
          eventList: _eventList,
          filteredEventList: _filteredEventList,
          searchController: _searchController,
          sortOrder: _sortOrder,
          onSortOrderChanged: (value) {
            setState(() {
              _sortOrder = value!;
              _sortEvents();
            });
          },
          onEventEdited: _navigateToEditEventPage,
          onEventDeleted: (index) {
            setState(() {
              _eventList.removeAt(index);
              _filterEvents();
            });
          },
        ),
        Container(), // Placeholder for AddEventPage
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista de eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Adicionar Eventos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFFE6285A),
        onTap: (index) {
          if (index == 1) {
            _navigateToAddEventPage();
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}

class EventListPage extends StatelessWidget {
  final List<Event> eventList;
  final List<Event> filteredEventList;
  final TextEditingController searchController;
  final String sortOrder;
  final ValueChanged<String?> onSortOrderChanged;
  final Function(Event, int) onEventEdited;
  final Function(int) onEventDeleted;

  EventListPage({
    required this.eventList,
    required this.filteredEventList,
    required this.searchController,
    required this.sortOrder,
    required this.onSortOrderChanged,
    required this.onEventEdited,
    required this.onEventDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Eventos'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortOrder,
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Data Ascendente')),
                DropdownMenuItem(value: 'desc', child: Text('Data Descendente')),
              ],
              onChanged: onSortOrderChanged,
              dropdownColor: Color(0xFF202020),
              style: TextStyle(color: Color(0xFFE6285A)),
              icon: Icon(Icons.sort, color: Color(0xFFE6285A)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Buscar eventos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: filteredEventList.isEmpty
                  ? Center(
                      child: Text('Nenhum evento encontrado',
                          style: TextStyle(fontSize: 18, color: Colors.white)))
                  : ListView.builder(
                      itemCount: filteredEventList.length,
                      itemBuilder: (context, index) {
                        final event = filteredEventList[index];
                        return Card(
                          color: Color(0xFF303030),
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(event.name,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(
                              'Data: ${DateFormat.yMMMd().format(event.date)}\n'
                              'Endereço: ${event.address}\n'
                              'Contratante: ${event.contractor}\n'
                              'Ingressos vendidos: ${event.ticketsSold}\n'
                              'Classificação: ${event.classification}',
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    onEventEdited(event, index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    onEventDeleted(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contractorController = TextEditingController();
  final _ticketsSoldController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedClassification = 'L';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Evento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contractorController,
              decoration: InputDecoration(
                labelText: 'Contratante',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _ticketsSoldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingressos Vendidos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Data do Evento: ${DateFormat.yMMMd().format(_selectedDate)}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.calendar_today, color: Color(0xFFE6285A)),
              onTap: _pickDate,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedClassification,
              items: ['L', '12+', '16+', '18+']
                  .map((classification) => DropdownMenuItem(
                        value: classification,
                        child: Text(classification),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClassification = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Classificação',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newEvent = Event(
            name: _nameController.text,
            date: _selectedDate,
            address: _addressController.text,
            contractor: _contractorController.text,
            ticketsSold: int.parse(_ticketsSoldController.text),
            classification: _selectedClassification,
          );
          Navigator.pop(context, newEvent);
        },
        tooltip: 'Salvar Evento',
        child: Icon(Icons.check),
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class EditEventPage extends StatefulWidget {
  final Event event;

  EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _contractorController;
  late TextEditingController _ticketsSoldController;
  late DateTime _selectedDate;
  late String _selectedClassification;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _addressController = TextEditingController(text: widget.event.address);
    _contractorController = TextEditingController(text: widget.event.contractor);
    _ticketsSoldController = TextEditingController(text: widget.event.ticketsSold.toString());
    _selectedDate = widget.event.date;
    _selectedClassification = widget.event.classification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Evento',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contractorController,
              decoration: InputDecoration(
                labelText: 'Contratante',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _ticketsSoldController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ingressos Vendidos',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Data do Evento: ${DateFormat.yMMMd().format(_selectedDate)}',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.calendar_today, color: Color(0xFFE6285A)),
              onTap: _pickDate,
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedClassification,
              items: ['L', '12+', '16+', '18+']
                  .map((classification) => DropdownMenuItem(
                        value: classification,
                        child: Text(classification),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClassification = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Classificação',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final updatedEvent = Event(
            name: _nameController.text,
            date: _selectedDate,
            address: _addressController.text,
            contractor: _contractorController.text,
            ticketsSold: int.parse(_ticketsSoldController.text),
            classification: _selectedClassification,
          );
          Navigator.pop(context, updatedEvent);
        },
        tooltip: 'Salvar Evento',
        child: Icon(Icons.check),
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

class Event {
  String name;
  DateTime date;
  String address;
  String contractor;
  int ticketsSold;
  String classification;

  Event({
    required this.name,
    required this.date,
    required this.address,
    required this.contractor,
    required this.ticketsSold,
    required this.classification,
  });
}
