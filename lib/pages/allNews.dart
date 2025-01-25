import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/models/slider_model.dart';
import 'package:news_app/pages/articleView.dart';
import 'package:news_app/services/news.dart';
import 'package:news_app/services/slider_data.dart';

class AllNews extends StatefulWidget {
  String news;

  AllNews({required this.news});

  @override
  State<AllNews> createState() => _AllNewsState();
}

class _AllNewsState extends State<AllNews> {
  bool _loading = true;

  List<SliderModel> sliders = [];
  List<ArticleModel> articles = [];

  @override
  void initState() {
    getSlider();
    getNews();
    super.initState();
  }

  getNews() async {
    News newsData = News();
    await newsData.getNews();
    articles = newsData.news;
    setState(() {
      _loading = false;
    });
  }

  getSlider() async {
    SliderGetting sliderData = SliderGetting();
    await sliderData.getSlider();
    sliders = sliderData.sliderList;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.news} News',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Scales title size with width
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount:
                  widget.news == 'Breaking' ? sliders.length : articles.length,
              itemBuilder: (context, index) {
                return AllnewsSection(
                  image: widget.news == 'Breaking'
                      ? sliders[index].urlToImage ?? ''
                      : articles[index].urlToImage ?? '',
                  desc: widget.news == 'Breaking'
                      ? sliders[index].description ?? 'No Description Available'
                      : articles[index].description ??
                          'No Description Available',
                  title: widget.news == 'Breaking'
                      ? sliders[index].title ?? 'No Title Available'
                      : articles[index].title ?? 'No Title Available',
                  url: widget.news == 'Breaking'
                      ? sliders[index].url ?? ''
                      : articles[index].url ?? '',
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                );
              },
            ),
    );
  }
}

class AllnewsSection extends StatelessWidget {
  final String image, desc, title, url;
  final double screenWidth, screenHeight;

  AllnewsSection({
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Articleview(blogUrl: url),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, // Dynamic horizontal margin
          vertical: screenHeight * 0.01, // Dynamic vertical margin
        ),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(screenWidth * 0.03), // Scaled radius
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(screenWidth * 0.03)),
              child: CachedNetworkImage(
                imageUrl: image,
                width: double.infinity,
                height: screenHeight * 0.25, // Scaled height
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: screenHeight * 0.25,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: screenHeight * 0.25,
                  color: Colors.grey[300],
                  child: Center(
                      child: Icon(Icons.error,
                          size: screenWidth * 0.1, color: Colors.red)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03), // Dynamic padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045, // Scaled title size
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.01), // Dynamic spacing
                  // Description
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035, // Scaled description size
                      color: Colors.black54,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
