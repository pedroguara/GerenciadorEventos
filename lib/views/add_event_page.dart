import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';

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
