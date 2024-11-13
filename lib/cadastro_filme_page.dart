import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_application_1/filme.dart';

class CadastroFilmePage extends StatefulWidget {
  final Function(Filme) onSubmit;

  CadastroFilmePage({required this.onSubmit});

  @override
  _CadastroFilmePageState createState() => _CadastroFilmePageState();
}

class _CadastroFilmePageState extends State<CadastroFilmePage> {
  final _formKey = GlobalKey<FormState>();
  String titulo = '';
  String genero = '';
  String faixaEtaria = 'Livre';
  double pontuacao = 0;
  String descricao = '';
  int ano = 0;
  String imageUrl = '';
  int duracao = 0;

void _submitForm() {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    // Imprimir a URL da imagem para depuração
    print('URL da Imagem: $imageUrl');

    Filme novoFilme = Filme(
      id: DateTime.now().millisecondsSinceEpoch,
      titulo: titulo,
      genero: genero,
      faixaEtaria: faixaEtaria,
      duracao: duracao,
      pontuacao: pontuacao,
      descricao: descricao,
      ano: ano,
      imageUrl: imageUrl,
    );
    widget.onSubmit(novoFilme);
    Navigator.of(context).pop();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Filme')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
                onSaved: (value) => titulo = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Gênero'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o gênero';
                  }
                  return null;
                },
                onSaved: (value) => genero = value!,
              ),
              DropdownButtonFormField<String>(
                value: faixaEtaria,
                items: ['Livre', '10', '12', '14', '16', '18']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => faixaEtaria = value!,
                decoration: InputDecoration(labelText: 'Faixa Etária'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  return null;
                },
                onSaved: (value) => ano = int.parse(value!),
              ),
              RatingBar.builder(
                minRating: 0,
                maxRating: 5,
                itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) => pontuacao = rating,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 4,
                onSaved: (value) => descricao = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'URL da Imagem'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
                onSaved: (value) => imageUrl = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Cadastrar Filme'),
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
