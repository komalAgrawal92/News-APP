import 'package:flutter/material.dart';
import 'package:newsapp/helper/news.dart';
import 'package:newsapp/helper/source_news.dart';
import 'package:newsapp/models/source_model.dart';
import 'package:newsapp/widgets/blog_tile_all.dart';
import 'package:newsapp/widgets/blog_tile_source.dart';
import 'package:newsapp/models/article_model.dart';

class Home extends StatefulWidget {

  static int page = 1;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  
  
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  List<dynamic> articles = [];
  List<ArticleModel> pagewiseArticles = new List<ArticleModel>();
  bool isSource = false;
  bool _loading = true;
  bool isOldFirst = false;
  bool isSearch = false;
  bool scrollLoading = false;
  String searchWord = '';

  @override
  void initState() {
  
    super.initState();
    isSource ? getNewsSourceData() : getNewsData();
    _scrollController.addListener(() {
      
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
            if(!isSource){
       
        getNewsData();
       
            }
        
      }
    });
   
     
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  
  getNewsData() async {
    if(articles.length==0){
   articles = new List<ArticleModel>();
    }
    
     if (!scrollLoading ) {
      setState(() {
        scrollLoading = true;
      });
    News news = News();
    await news.getNews(isSearch, searchWord);
    pagewiseArticles=news.news;
   // articles = pagewiseArticles;
    print('length ${articles.length}');
    setState(() {
      _loading = false;
      
    });
      FocusScope.of(context).unfocus();
      setState(() {
        scrollLoading = false;
        articles.addAll(List<ArticleModel>.from(pagewiseArticles));
        Home.page++;
      });
    }
     
  }

  getNewsSourceData() async {
    SourceNewsClass newsSource = SourceNewsClass();
    await newsSource.getSourceNews();
    articles = newsSource.news_source;
    setState(() {
      _loading = false;
    });
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: isSearch
            ? IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    isSearch = false;
                    searchWord = '';
                    Home.page=1;
                    articles = isSource ? new List<SourceModel>() : new List<ArticleModel>(); 
                     pagewiseArticles.clear();
                    _loading = true;
                    getNewsData();
                  });
                })
            : Text(''),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (searchWord == '') {
                  isSearch = !isSearch;
                } else {
                  if (isSearch && searchWord != '') {
                    Home.page=1;
                    articles = isSource ? new List<SourceModel>() : new List<ArticleModel>(); 
                    pagewiseArticles.clear();
                    getNewsData();
                  }
                  ;
                }
              });
            },
          ),
          PopupMenuButton(
              onSelected: (selectedValue) {
                setState(() {
                  if (selectedValue == 0) {
                    if (!isOldFirst) {
                      articles = articles.reversed.toList();
                    }
                    isOldFirst = true;
                  } else {
                    if (isOldFirst) {
                      articles = articles.reversed.toList();
                    }
                    isOldFirst = false;
                  }
                });
              },
              icon: isOldFirst
                  ? Icon(Icons.north_sharp)
                  : Icon(Icons.south_sharp),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Old First'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('Recent First'),
                      value: 1,
                    ),
                  ]),
          PopupMenuButton(
              onSelected: (selectedValue) {
                setState(() {
                  Home.page=1;
                  articles = isSource ? new List<SourceModel>() : new List<ArticleModel>(); 
                  pagewiseArticles.clear();
                  _loading = true;
                  if (selectedValue == 0) {
                    isSource = true;
                    getNewsSourceData();
                  } else {
                    isSource = false;
                    getNewsData();
                  }
                });
              },
              icon: isSource
                  ? Icon(Icons.filter_alt_sharp)
                  : Icon(Icons.filter_alt_outlined),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('By Source'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('Show All'),
                      value: 1,
                    ),
                  ]),
        ],
        title: isSearch
            ? Row(
              children: [
                Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 6.0, bottom: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: TextFormField(
                          autofocus: true,
                          onChanged: (String text) {
                            searchWord = text;

                          },
                          controller: _controller,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 5.0),
                              hintText: 'Search Here',
                              border: InputBorder.none),
                        ))),
              ],
            )
            : (isSource
                ? Text('Source News',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.redAccent))
                : Text('Recent News',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.redAccent))),
        elevation: 0.8,
      ),
      body: Stack(
        
        children: [

          _loading 
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
            controller: _scrollController,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 16),
                        child:  ListView.builder(
                          
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              
                              return isSource
                                  ? BlogTileSource(
                                      title: articles[index].title,
                                      desc: articles[index].description,
                                      url: articles[index].url)
                                  : BlogTile(
                                      imageUrl: articles[index].urlToImage,
                                      title: articles[index].title,
                                      desc: articles[index].description,
                                      url: articles[index].url);
                            
                            }
                           
                            ),
                            )
                  ],
                ),
              ),
            ),
            
            scrollLoading && !_loading ? Center(
                  child:Container(
                    alignment: Alignment.bottomCenter,
child: CircularProgressIndicator(

                ),
                  )
                
              
            ): Text(''),
        ]  
    ));
  }
}
