import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes_app/fav_provider_model.dart';
import 'package:quotes_app/home_screen.dart';

class FavouriteScreen extends StatefulWidget {

  FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  HomeScreen homeScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavProviderModel>(
      builder: (context, value, child) =>
          Scaffold(
            appBar: AppBar(
              title: Text('Favourites'),
            ),
            body: Column(
              children: [
                Expanded(
              child: ListView.builder(
                  itemCount: value.getQuoteList.length,
                  itemBuilder: (context, index){
                      int ind = index + 1;
                    return ListTile(
                      leading: Text(ind.toString()),
                      title: Text(value.getQuoteList[index]),
                      trailing: InkWell(
                          onTap: (){
                            setState(() {
                              value.getQuoteList.remove(value.getQuoteList[index]);
                            });
                          },
                          child: Icon(Icons.delete, size: 28,)
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
