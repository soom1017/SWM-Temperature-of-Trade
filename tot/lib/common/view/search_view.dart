import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:multiple_search_selection/helpers/create_options.dart';
import 'package:multiple_search_selection/multiple_search_selection.dart';
import 'package:tot/common/data/cache.dart';
import 'package:tot/common/layout/default_layout.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

TextStyle kStyleDefault = const TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);


class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      isExtraPage: true,
      pageName: "검색",
      child: MultipleSearchSelection<Country>(
        clearSearchFieldOnSelect: true,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '키워드 리스트',
            style: kStyleDefault.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onItemAdded: (c) {
          Future.delayed(Duration(milliseconds: 1000), () {
            print(c.toString());
            setState(() {

            });
          });
        },

        items: countries, // List<Country>
        fieldToCheck: (c) {
          return c.name;
        },
        itemBuilder: (country) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 12,
                ),
                child: Text(country.name),
              ),
            ),
          );
        },
        pickedItemBuilder: (country) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(country.name),
            ),
          );
        },
        // showedItemsBoxDecoration:BoxDecoration(color: Colors.red),
        // sortShowedItems: true,
        // sortPickedItems: true,
        selectAllButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select All',
                style: kStyleDefault,
              ),
            ),
          ),
        ),
        clearAllButton: Padding(
          padding: const EdgeInsets.all(12.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clear All',
                style: kStyleDefault,
              ),
            ),
          ),
        ),
        fuzzySearch: FuzzySearch.jaro,
        itemsVisibility: ShowedItemsVisibility.onType,
        showSelectAllButton: false,
        searchFieldInputDecoration: InputDecoration(
          hintText: '검색어를 입력하세요',
          hintStyle: kStyleDefault.copyWith(
            fontSize: 13,
            color: Colors.grey[400],
          ),
        ),
        pickedItemsBoxDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue[300]!,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        showedItemsBackgroundColor: Colors.grey.withOpacity(0.1),
        showShowedItemsScrollbar: false,
        noResultsWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'No items found',
            style: kStyleDefault.copyWith(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
      ),
    );
  }
}

List<Country> countries = List<Country>.generate(
  keywordList.length,
      (index) => Country(
    name: keywordList[index],
  ),
);

class Country {
  final String name;

  const Country({
    required this.name,
  });
}