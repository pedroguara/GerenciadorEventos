import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/event_controller.dart';
import 'add_event_page.dart';
import 'edit_event_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gerenciador de Eventos'),
          actions: [
            Consumer<EventController>(
              builder: (context, controller, child) {
                return DropdownButton<String>(
                  value: controller.sortOrder, // Correto agora
                  items: [
                    DropdownMenuItem(value: 'asc', child: Text('Data Ascendente')),
                    DropdownMenuItem(value: 'desc', child: Text('Data Descendente')),
                  ],
                  onChanged: (value) {
                    controller.setSortOrder(value!);
                  },
                  dropdownColor: Color(0xFF202020),
                  style: TextStyle(color: Color(0xFFE6285A)),
                  underline: Container(),
                  icon: Icon(Icons.sort, color: Color(0xFFE6285A)),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Consumer<EventController>(
                builder: (context, controller, child) {
                  return TextField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar eventos',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              Expanded(
                child: Consumer<EventController>(
                  builder: (context, controller, child) {
                    if (controller.eventList.isEmpty) {
                      return Center(
                        child: Text('Nenhum evento encontrado',
                            style: TextStyle(fontSize: 18, color: Colors.white)),
                      );
                    }
                    return ListView.builder(
                      itemCount: controller.eventList.length,
                      itemBuilder: (context, index) {
                        final event = controller.eventList[index];
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
                                      controller.updateEvent(index, result);
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    controller.removeEvent(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
              Provider.of<EventController>(context, listen: false).addEvent(result);
            }
          },
          tooltip: 'Adicionar Evento',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
