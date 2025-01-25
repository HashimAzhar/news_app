import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/slider_model.dart';

class SliderGetting {
  List<SliderModel> sliderList = [];

  Future<void> getSlider() async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=6b1baf0ca598482283b11a651425dae2';

    var response = await http.get(Uri.parse(url));
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          SliderModel sliderModel = SliderModel(
            title: element['title'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            content: element['content'],
            author: element['author'],
          );
          sliderList.add(sliderModel);
        }
      });
    }
  }
}
