import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:newsapp/helper/news.dart';
import 'package:newsapp/models/source_model.dart';

class SourceNewsClass {
  List<SourceModel> news_source = [];

  Future<void> getSourceNews() async {
    final url =
        'https://newsapi.org/v2/sources?sortBy=publishedAt&apiKey=${News.API_KEY}';

    try {
      var response = await http.get(Uri.parse(url));

      var jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'ok') {
        jsonData['sources'].forEach((element) {
          if (element['url'] != null && element['description'] != null) {
            SourceModel sourceModel = new SourceModel(
              title: element['name'],
              description: element['description'],
              url: element['url'],
            );

            news_source.add(sourceModel);
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
