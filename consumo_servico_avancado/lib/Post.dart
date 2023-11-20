//Definindo atributos
class Post {
  int _userId;
  int _id;
  String _title;
  String _body;

  //criando construtores
  Post(this._userId, this._id, this._title, this._body);

  Map toJson() {
    return {
      "userId": this._userId,
      "id": this._id,
      "title": this._title,
      "body": this._body
    };
  }

  String get body => _body;

  get id => _id;

  set body(String value) {
    _body = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}
