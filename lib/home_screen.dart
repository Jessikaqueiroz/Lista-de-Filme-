import 'package:flutter/material.dart';
import 'package:flutter_application_1/filme.dart';
import 'package:flutter_application_1/detalhes_filme_page.dart';
import 'package:flutter_application_1/cadastro_filme_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Filme> filmes = [];

  // Função para adicionar filme
  void _addFilme(Filme filme) {
    setState(() {
      filmes.add(filme);
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
        title: Text('Lista de Filmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: Text("Nome do Grupo"),
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
          return Dismissible(
            key: ValueKey(filmes[index].id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              _deleteFilme(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              leading: filmes[index].imageUrl.isNotEmpty
                    ? Image.network(
                        filmes[index].imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.movie),
              title: Text(filmes[index].titulo),
              subtitle: Text(filmes[index].genero),
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
            builder: (ctx) => CadastroFilmePage(onSubmit: _addFilme), // Passando corretamente a função _addFilme
          ),
        ),
      ),
    );
  }
}
