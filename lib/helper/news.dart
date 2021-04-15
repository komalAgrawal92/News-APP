import 'dart:convert';
import 'dart:async';
import 'package:newsapp/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/views/home.dart';

class News {
  List<ArticleModel> news = [];

  static const String API_KEY = '63e8633e53b94133b4b7f567c650c39f';

  Future<void> getNews(bool isSearch, String searchWord) async {
    var url;
    isSearch
        ? url =
            'https://newsapi.org/v2/top-headlines?q=$searchWord&country=in&page=${Home.page}&sortBy=publishedAt&apiKey=$API_KEY'
        : url =
            'https://newsapi.org/v2/top-headlines?country=in&page=${Home.page}&sortBy=publishedAt&apiKey=$API_KEY';

    try {
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'ok') {
        jsonData['articles'].forEach((element) {
          if (element['urlToImage'] != null && element['description'] != null) {
            ArticleModel articleModel = new ArticleModel(
              author: element['author'],
              title: element['title'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              content: element['content'],
            );

            news.add(articleModel);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
