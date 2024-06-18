import 'package:flutter/material.dart';
import 'package:gerenciador_eventos/controllers/event_controller.dart';
import 'package:gerenciador_eventos/provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final eventController = EventController(eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Eventos'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: eventProvider.sortOrder,
              items: [
                DropdownMenuItem(value: 'asc', child: Text('Data Ascendente')),
                DropdownMenuItem(value: 'desc', child: Text('Data Descendente')),
              ],
              onChanged: (String? value) => eventProvider.changeSortOrder(value!),
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
              controller: eventProvider.searchController,
              decoration: InputDecoration(
                labelText: 'Buscar eventos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: eventProvider.filteredEventList.isEmpty
                  ? Center(
                child: Text(
                  'Nenhum evento encontrado',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: eventProvider.filteredEventList.length,
                itemBuilder: (context, index) {
                  final event = eventProvider.filteredEventList[index];
                  return Card(
                    color: Color(0xFF303030),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(event.name, style: TextStyle(color: Colors.white)),
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
                              eventController.editEvent(context, event, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              eventController.deleteEvent(index);
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
