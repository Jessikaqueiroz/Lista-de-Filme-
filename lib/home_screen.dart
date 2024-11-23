import 'package:flutter/material.dart';
import 'package:flutter_application_1/filme.dart';
import 'package:flutter_application_1/detalhes_filme_page.dart';
import 'package:flutter_application_1/cadastro_filme_page.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Filme> filmes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Função para adicionar filme
  void _addFilme(Filme filme) {
    setState(() {
      filmes.add(filme);
      
    });
  }
  // Função para alterar filme
  void _updateFilme(Filme updatedFilme) {
    setState(() {
      int index = filmes.indexWhere((f) => f.id == updatedFilme.id);
      if (index != -1) {
        filmes[index] = updatedFilme;
      }
    });
  }

  // Função para excluir filme
  void _deleteFilme(int index) {
    setState(() {
      filmes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Mostrar o alerta com o nome da equipe
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Equipe"),
                  content: Text("Jéssika Queiroz, Daniel Andrade e Elliabe Henrique"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Fechar"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filmes.length,
        itemBuilder: (ctx, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: filmes[index].imageUrl.isNotEmpty
                  ? Image.network(
                      filmes[index].imageUrl,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.movie, size: 60),
              title: Text(
                filmes[index].titulo,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    filmes[index].genero,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    "${filmes[index].duracao} min",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 6),
                  RatingBarIndicator(
                    rating: filmes[index].pontuacao,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              isThreeLine: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => DetalhesFilmePage(filme: filmes[index]),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => CadastroFilmePage(onSubmit: _addFilme),
          ),
        ),
      ),
    );
  }
}
