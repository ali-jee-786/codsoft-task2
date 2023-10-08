import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quotes_app/fav_provider_model.dart';
import 'package:quotes_app/favourite_screen.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen ({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String quote, owner, bg_img;
  bool working = false;
  bool is_favourite = false;
  // List<String> getQuoteList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quote = "";
    owner = "";
    bg_img = "";
    getQuotes();
  }
  getQuotes() async {
    try {
      setState(() {
        is_favourite = false;
        quote = owner = bg_img = "";
        working = true;
      });
      var response = await http.post(
          Uri.parse('http://api.forismatic.com/api/1.0/'),
          body: {
            "method": "getQuote",
            "format": "json",
            "lang": "en"
          });

      setState(() {
        try {
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            owner = data['quoteAuthor'].toString();
            quote = data['quoteText'].toString();
            getImage(owner);
            // print('done');
          }
          else {
            throw Exception('Error');
          }
        } catch (e) {
          // offline();
        }
      });
    } catch (e) {
      offline();
    }
  }
  offline(){
    setState(() {
      working = false;
      bg_img = 'assets/images/offline_pic.jpg';
      quote = 'What the mind of a man can conceive & believe, it can achieve';
      owner = 'Napoleon Hill';
    });
  }
  getImage(String owner) async {
    final response = await http.get(Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&generator=search&gsrlimit=1&prop=pageimages%7Cextracts&pithumbsize=4006&gsrsearch=$owner&format=json'));
    setState(() {
      try {
        var data = jsonDecode(response.body)['query']['pages'];
        data = data[data.keys.first];
        bg_img = data['thumbnail']['source'];
      } catch (e) {
        bg_img = '';
        working = false;
      }
    });
  }
  Widget drawImage() {
    if (bg_img.isEmpty || working==false) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Image(
          image: AssetImage('assets/images/offline_pic.jpg'),
          fit: BoxFit.cover,
        ),
      );
    }
    else {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: bg_img,
      );
    }
  }
  shareQuote() async {
    Share.share('$quote\n~ $owner');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavProviderModel>(
      builder: (context, value, child) =>
          Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      getQuotes();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.refresh, color: Colors.white, size: 27,),
                        Text('  Reload', style: TextStyle(color: Colors.white),)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if((quote.isNotEmpty && owner.isNotEmpty) || (quote.isNotEmpty || owner.isNotEmpty)){
                        setState(() {
                          if (value.getQuoteList.contains('$quote ~$owner')) {
                            value.getQuoteList.remove('$quote ~$owner');
                            is_favourite = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Removed form favourite!"), duration: Duration(seconds: 1),)
                            );
                          } else {
                            value.getQuoteList.add('$quote ~$owner');
                            is_favourite = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Added to favourite!"), duration: Duration(seconds: 1),)
                            );
                          }
                        });

                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Can't assigned as fav!"), duration: Duration(seconds: 1))
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Icon(is_favourite? Icons.favorite : Icons.favorite_border,
                            color: Colors.white, size: 27
                        ),
                        Text('  Favourite', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      shareQuote();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.share, color: Colors.white, size: 27),
                        Text('  Share', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body:
            Stack(
              fit: StackFit.expand,
              children: <Widget> [
                drawImage(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(1)
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 490,),

                        Text('" $quote "', textAlign: TextAlign.center,
                          style: GoogleFonts.actor(color: Colors.white,height: 1.5,
                              fontSize: MediaQuery.sizeOf(context).height * 0.026,
                              fontWeight: FontWeight.bold),
                        ),
                        Text('\n~ $owner',
                          style: GoogleFonts.abel(color: Colors.grey.shade400,
                              fontSize: MediaQuery.sizeOf(context).height * 0.022,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 45,),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context)=>FavouriteScreen()
                          ));
                        },
                        child: const CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.black,
                            child: Icon(Icons.favorite, size: 35,color: Colors.redAccent,)),
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