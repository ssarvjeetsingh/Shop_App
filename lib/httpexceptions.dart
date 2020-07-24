

class HttpException implements Exception{

  final String message;

  HttpException(this.message);


  String tooString()
  {
    return message;
  }


}