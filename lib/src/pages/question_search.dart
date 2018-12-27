import 'package:flutter/material.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/pages/view_ad_page.dart';
import 'package:my_car/src/pages/view_question.dart';
import 'package:my_car/src/views/search_list_item.dart';

const _tag = 'QuestionsSearch:';

class QuestionsSearch extends SearchDelegate<Question> {
  final List<Question> questionsList;
  final List<Ad> adsList;
  QuestionsSearch({this.questionsList, this.adsList});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchableList = [];
    adsList.forEach((ad) => searchableList.add(ad));
    questionsList.forEach((question) => searchableList.add(question));
    searchableList.shuffle();
    final results = _getResults(searchableList);

    return ListView(
      children: results
          .map<SearchListItemView>((result) => SearchListItemView(
              heading: _getHeading(result),
              imageUrl: _getImage(result),
              onTap: () => _handleOnTap(context, result)))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchableList = [];
    adsList.forEach((ad) => searchableList.add(ad));
    questionsList.forEach((question) => searchableList.add(question));
    searchableList.shuffle();
    final results = _getResults(searchableList);

    // return ListView.builder(
    //   itemCount: results.length,
    //   itemBuilder: (context, index) {
    //     return SearchListItemView(
    //       key: Key(results[index].id),
    //       heading: _getHeading(results[index]),
    //       imageUrl: _getImage(results[index]),
    //       onTap: () => _handleOnTap(context, results[index]),
    //     );
    //   },
    // );

    return ListView(
      children: results
          .map<SearchListItemView>((result) => SearchListItemView(
              heading: _getHeading(result),
              imageUrl: _getImage(result),
              onTap: () => _handleOnTap(context, result)))
          .toList(),
    );
  }

  _getResults(dynamic searchableList) {
    print('$_tag at _getResults');
    return searchableList;
    return searchableList.where((searchItem) {
      switch (searchItem.runtimeType) {
        case Question:
          // searchItem.question.toLowerCase().contains(query.toLowerCase());
          break;
        case Ad:
          // searchItem.description.toLowerCase().contains(query.toLowerCase());
          break;
        default:
          print('$_tag unexpected type: ${searchItem.runtimeType}');
      }
    });
  }

  _handleOnTap(BuildContext context, dynamic result) {
    print('$_tag at _handleOnTap');
    switch (result.runtimeType) {
      case Question:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewQuestionPage(
                      question: result,
                      key: Key(result.id),
                    )));
        break;
      case Ad:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewAdPage(ad: result, key: Key(result.id))));
        break;
      default:
        print('$_tag unexpected result type: ${result.runtimeType}');
        return null;
    }
  }

  String _getHeading(dynamic result) {
    print('$_tag at _getHeading');
    switch (result.runtimeType) {
      case Ad:
        return result.description;
        break;
      case Question:
        return result.question;
        break;
      default:
        print('$_tag unexpected result type: ${result.runtimeType}');
        return null;
    }
  }

  String _getImage(dynamic result) {
    print('$_tag at _getImage');
    switch (result.runtimeType) {
      case Question:
        return result.userImageUrl;
        break;
      case Ad:
        return result.imageUrl != null ? result.imageUrl : result.userImgeUrl;
        break;
      default:
        print('$_tag unexpected result type: ${result.runtimeType}');
        return null;
    }
  }
}
