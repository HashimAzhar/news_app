import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/showCategory.dart';
import 'package:news_app/pages/articleView.dart';
import 'package:news_app/services/showCategoryNews.dart';

class CategoryNews extends StatefulWidget {
  final String name;

  CategoryNews({required this.name});

  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ShowCategoryModel> categories = [];
  bool _isLoading = true;

  getNews() async {
    ShowCategoryNews categoryData = ShowCategoryNews();
    await categoryData.getCategoryNews(widget.name);
    categories = categoryData.categoryList;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.name,
            style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.05),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ShowCategoryTile(
                  image: categories[index].urlToImage ?? '',
                  desc: categories[index].description ??
                      'No Description Available',
                  title: categories[index].title ?? 'No Title Available',
                  url: categories[index].url ?? '',
                  screenWidth: screenWidth,
                );
              },
            ),
    );
  }
}

class ShowCategoryTile extends StatelessWidget {
  final String image, desc, title, url;
  final double screenWidth;

  ShowCategoryTile({
    required this.image,
    required this.desc,
    required this.title,
    required this.url,
    required this.screenWidth,
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
        margin:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: image,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                      child: Icon(Icons.error, size: 50, color: Colors.red)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  // Description
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
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
