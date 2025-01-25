import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/showCategory.dart';

class ShowCategoryNews {
  List<ShowCategoryModel> categoryList = [];

  Future<void> getCategoryNews(String category) async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=6b1baf0ca598482283b11a651425dae2';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ShowCategoryModel showCategoryModel = ShowCategoryModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
            author: element['author'],
          );
          categoryList.add(showCategoryModel);
        }
      });
    }
  }
}
