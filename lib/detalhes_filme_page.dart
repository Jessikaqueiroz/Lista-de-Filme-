import 'package:flutter/material.dart';
import 'filme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetalhesFilmePage extends StatelessWidget {
  final Filme filme;

  DetalhesFilmePage({required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filme.titulo),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(filme.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text('Título: ${filme.titulo}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Gênero: ${filme.genero}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Faixa Etária: ${filme.faixaEtaria}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Duração: ${filme.duracao} minutos', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Ano: ${filme.ano}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Descrição:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(filme.descricao, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Pontuação:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RatingBar.builder(
              initialRating: filme.pontuacao,
              minRating: 0,
              maxRating: 5,
              direction: Axis.horizontal,
              itemCount: 5,
              itemSize: 30.0,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {},
              ignoreGestures: true, // Torna o RatingBar somente para exibição
            ),
          ],
        ),
      ),
    );
  }
}
