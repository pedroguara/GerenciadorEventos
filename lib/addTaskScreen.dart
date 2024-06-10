import 'package:flutter/material.dart';

// Classe para representar uma tarefa
class Task {
  String titulo;
  String descricao;
  String ra;
  DateTime data;

  Task({required this.titulo, required this.descricao, required this.ra, required this.data});
}

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _raController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 25, 25),
        title: Text('Atividade Flutter - Grupo 6'), foregroundColor: Colors.amber,
      ),
      body: Container(
        color: const Color.fromARGB(255, 104, 103, 103),
        child: Padding( 
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.amber),
                ),
                style: TextStyle(color: Colors.amber),
              ),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: Colors.amber),
                ),
                style: TextStyle(color: Colors.amber),
              ),
              TextField(
                controller: _raController,
                decoration: InputDecoration(
                  labelText: 'RA',
                  labelStyle: TextStyle(color: Colors.amber),
                ),
                style: TextStyle(color: Colors.amber),
              ),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(
                  labelText: 'Data',
                  labelStyle: TextStyle(color: Colors.amber),
                ),
                style: TextStyle(color: Colors.amber),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Criar uma nova tarefa com os valores dos campos de texto
                  Task newTask = Task(
                    titulo: _tituloController.text,
                    descricao: _descricaoController.text,
                    ra: _raController.text,
                    data: DateTime.parse(_dataController.text),
                  );
                  // Voltar para a tela anterior e enviar a nova tarefa
                  Navigator.pop(context, newTask);
                },
                child: Text('Adicionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
