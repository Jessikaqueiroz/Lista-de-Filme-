import 'package:flutter/material.dart';
import 'package:flutter_application_1/filme.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class CadastroFilmePage extends StatefulWidget {
  final Function(Filme) onSubmit;
  final Filme? filme;

  CadastroFilmePage({required this.onSubmit, this.filme});

  @override
  _CadastroFilmePageState createState() => _CadastroFilmePageState();
}

class _CadastroFilmePageState extends State<CadastroFilmePage> {
  final _formKey = GlobalKey<FormState>();
  late String titulo;
  late String genero;
  late String faixaEtaria;
  late double pontuacao;
  late String descricao;
  late int ano;
  late String imageUrl;
  late int duracao;

  final List<String> faixaEtariaOptions = ['Livre', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      titulo = widget.filme!.titulo;
      genero = widget.filme!.genero;
      faixaEtaria = widget.filme!.faixaEtaria;
      pontuacao = widget.filme!.pontuacao;
      descricao = widget.filme!.descricao;
      ano = widget.filme!.ano;
      imageUrl = widget.filme!.imageUrl;
      duracao = widget.filme!.duracao;
    } else {
      titulo = '';
      genero = '';
      faixaEtaria = 'Livre';
      pontuacao = 0;
      descricao = '';
      ano = 0;
      imageUrl = '';
      duracao = 0;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Filme novoFilme = Filme(
        id: widget.filme?.id ?? DateTime.now().millisecondsSinceEpoch,
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
      appBar: AppBar(
        title: Text(widget.filme == null ? 'Cadastrar Filme' : 'Alterar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Campo para título
                TextFormField(
                  initialValue: titulo,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    titulo = value!;
                  },
                ),
                
                // Campo para gênero
                TextFormField(
                  initialValue: genero,
                  decoration: InputDecoration(labelText: 'Gênero'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o gênero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    genero = value!;
                  },
                ),
                
                // Campo para faixa etária (DropDownButton)
                DropdownButtonFormField<String>(
                  value: faixaEtaria,
                  decoration: InputDecoration(labelText: 'Faixa Etária'),
                  items: faixaEtariaOptions.map((String faixa) {
                    return DropdownMenuItem<String>(
                      value: faixa,
                      child: Text(faixa),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      faixaEtaria = value!;
                    });
                  },
                  onSaved: (value) {
                    faixaEtaria = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Escolha a faixa etária';
                    }
                    return null;
                  },
                ),
                
                // Campo para descrição (com maxLines)
                TextFormField(
                  initialValue: descricao,
                  decoration: InputDecoration(labelText: 'Descrição'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe uma descrição';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    descricao = value!;
                  },
                  maxLines: 5,  // Permitir até 5 linhas de texto
                ),
                
                // Campo para ano
                TextFormField(
                  initialValue: ano != 0 ? ano.toString() : '',
                  decoration: InputDecoration(labelText: 'Ano'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o ano';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ano = int.parse(value!);
                  },
                ),
                
                // Campo para imagem (URL)
                TextFormField(
                  initialValue: imageUrl,
                  decoration: InputDecoration(labelText: 'URL da Imagem'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a URL da imagem';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    imageUrl = value!;
                  },
                ),
                
                // Campo para duração
                TextFormField(
                  initialValue: duracao != 0 ? duracao.toString() : '',
                  decoration: InputDecoration(labelText: 'Duração (minutos)'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a duração';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    duracao = int.parse(value!);
                  },
                ),
                
                // Campo para pontuação (SmoothStarRating)
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Pontuação:'),
                    SizedBox(width: 8),
                    SmoothStarRating(
                      rating: pontuacao,
                      size: 40,
                      allowHalfRating: true, // Permitir meia estrela
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      onRatingChanged: (value) {  // Usando o parâmetro correto
                        setState(() {
                          pontuacao = value;
                        });
                      },
                    ),
                  ],
                ),
                
                // Botão para salvar os dados
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.filme == null ? 'Cadastrar' : 'Alterar'),
                ),

                // Exibindo os dados do filme (após cadastro)
                if (widget.filme != null) ...[
                  SizedBox(height: 20),
                  Text('Dados do Filme:'),
                  Text('Título: $titulo'),
                  Text('Gênero: $genero'),
                  Text('Faixa Etária: $faixaEtaria'),
                  Text('Descrição: $descricao'),
                  Text('Ano: $ano'),
                  Text('Duração: $duracao minutos'),
                  Text('Pontuação: $pontuacao'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
