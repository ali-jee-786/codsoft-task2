

import 'package:flutter/cupertino.dart';

class FavProviderModel extends ChangeNotifier{

  List<String> getQuoteList = [];
  bool is_favourite = false;
  late String quote;

//   void addQuote(){
//     getQuoteList.add(quote); // Add to favorites
//     notifyListeners();
//   }
// void removeQuote(){
//   getQuoteList.remove(quote); // Remove from favorites
//   notifyListeners();
// }

}