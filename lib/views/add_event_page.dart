import 'package:flutter/material.dart';
import 'package:gerenciador_eventos/controllers/event_controller.dart';
import 'package:gerenciador_eventos/provider/provider.dart';
import 'package:gerenciador_eventos/views/EventListPage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: MaterialApp(
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
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final eventController = EventController(eventProvider);

    return Scaffold(
      body: IndexedStack(
        index: eventProvider.selectedIndex,
        children: [
          EventListPage(),
          Container(), // Placeholder for AddEventPage
        ],
      ),
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
        currentIndex: eventProvider.selectedIndex,
        selectedItemColor: Color(0xFFE6285A),
        onTap: (index) {
          if (index == 1) {
            eventController.addEvent(context);
          } else {
            eventProvider.changeSelectedIndex(index);
          }
        },
      ),
    );
  }
}
