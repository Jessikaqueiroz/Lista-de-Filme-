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

  @override
  void initState() {
    super.initState();
    _loadFilmes();
  }

  // Carregar filmes da base de dados
  void _loadFilmes() async {
    filmes = await _dbHelper.fetchFilmes();
    setState(() {});
  }

  // Função para adicionar filme
  void _addFilme(Filme filme) {
    setState(() {
      filmes.add(filme);
    });
    _dbHelper.insertFilme(filme);
  }

  // Função para excluir filme
  void _deleteFilme(int id) async {
    setState(() {
      filmes.removeWhere((filme) => filme.id == id);
    });
    await _dbHelper.deleteFilme(id);
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
          return Dismissible(
            key: Key(filmes[index].id.toString()), // Usando o id como chave única
            direction: DismissDirection.endToStart, // Direção do deslize (da direita para a esquerda)
            onDismissed: (direction) {
              _deleteFilme(filmes[index].id!); // Deletando o filme
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Filme deletado com sucesso!')),
              );
            },
            background: Container(
              color: Colors.red, // Cor do fundo durante o gesto de exclusão
              child: Icon(Icons.delete, color: Colors.white, size: 40),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
            ),
            child: Card(
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
                // Menu de opções para cada filme
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'detalhes') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetalhesFilmePage(filme: filmes[index]),
                        ),
                      );
                    } else if (value == 'alterar') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => CadastroFilmePage(
                            onSubmit: (Filme updatedFilme) {
                              setState(() {
                                filmes[index] = updatedFilme;
                              });
                              _dbHelper.updateFilme(updatedFilme);
                            },
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'detalhes',
                      child: Text('Exibir Dados'),
                    ),
                    PopupMenuItem(
                      value: 'alterar',
                      child: Text('Alterar'),
                    ),
                  ],
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
