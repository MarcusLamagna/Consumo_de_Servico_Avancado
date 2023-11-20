import 'package:consumo_servico_avancado/Post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Consumindo API
  String _urlBase = "https://jsonplaceholder.typicode.com/";

  //Recuperando/retornando lista de itens
  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse("$_urlBase/posts"));
    var dadosJson = json.decode(response.body);

    //Criando lista
    List<Post> postagens = [];

    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    //Retornando postagens
    return postagens;
  }

  //Criando método salvar, atualizar e deletar
  _post() async {
    Post post = new Post(120, 1, "Titulo", "Corpo da postagem");

    var corpo = json.encode(post.toJson());
    http.Response response = await http.post(Uri.parse("$_urlBase/posts"),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo);
    print("resposta: ${response.statusCode}"); //Verifica se deu tudo certo
    print("resposta: ${response.body}"); //Retonra o corpo da página
  }

  //Put atualiza recursos dentro de uma API
  _put() async {
    var corpo = json.encode({
      "userId": 120,
      "id": null,
      "title": "Titulo alterado",
      "body": "Corpo da postagem alterada"
    });
    http.Response response = await http.put(Uri.parse("$_urlBase/posts/2"),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo);
    print("resposta: ${response.statusCode}"); //Verifica se deu tudo certo
    print("resposta: ${response.body}"); //Retonra o corpo da página
  }

  _patch() async {
    var corpo = json.encode({
      "userId": 120,
      //"id": null,
      //"title": null,
      "body": "Corpo da postagem alterada"
    });
    http.Response response = await http.patch(Uri.parse("$_urlBase/posts/2"),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo);
    print("resposta: ${response.statusCode}"); //Verifica se deu tudo certo
    print("resposta: ${response.body}"); //Retonra o corpo da página
  }

  _delete() async {
    http.Response response = await http.delete(Uri.parse("$_urlBase/posts/2"));
    print("resposta: ${response.statusCode}"); //Verifica se deu tudo certo
    print("resposta: ${response.body}"); //Retonra o corpo da página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(onPressed: _post, child: Text("Salvar")),
                ElevatedButton(onPressed: _patch, child: Text("Atualizar")),
                ElevatedButton(onPressed: _delete, child: Text("Deletar")),
              ],
            ),

            //Expanded
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _recuperarPostagens(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print("lista: Erro ao carregar ");
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              //Exibir Itens
                              List<Post> lista = snapshot.data!;
                              //Recuparando Post
                              Post post = lista[index];

                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            });
                      }
                      break;
                  }
                  return Text('algum erro...');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
