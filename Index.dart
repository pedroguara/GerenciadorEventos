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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Eventos'),
        actions: [
          DropdownButton<String>(
            value: _sortOrder,
            items: [
              DropdownMenuItem(value: 'asc', child: Text('Data Ascendente')),
              DropdownMenuItem(value: 'desc', child: Text('Data Descendente')),
            ],
            onChanged: (value) {
              setState(() {
                _sortOrder = value!;
                _sortEvents();
              });
            },
            dropdownColor: Color(0xFF202020),
            style: TextStyle(color: Color(0xFFE6285A)),
            underline: Container(),
            icon: Icon(Icons.sort, color: Color(0xFFE6285A)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar eventos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _filteredEventList.isEmpty
                  ? Center(
                      child: Text('Nenhum evento encontrado',
                          style: TextStyle(fontSize: 18, color: Colors.white)))
                  : ListView.builder(
                      itemCount: _filteredEventList.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEventList[index];
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
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => EditEventPage(event: event),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          var begin = Offset(1.0, 0.0);
                                          var end = Offset.zero;
                                          var curve = Curves.ease;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(tween);
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: Duration(milliseconds: 300),
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        _eventList[index] = result;
                                        _filterEvents();
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _eventList.removeAt(index);
                                      _filterEvents();
                                    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => AddEventPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                var begin = Offset(1.0, 0.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 300),
            ),
          );
          if (result != null) {
            setState(() {
              _eventList.add(result);
              _filterEvents();
            });
          }
        },
        tooltip: 'Adicionar Evento',
        child: Icon(Icons.add),
      ),
    );
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
