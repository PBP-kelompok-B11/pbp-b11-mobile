// To parse this JSON data, do
//
//     final response = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) =>
    SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) =>
    json.encode(data.toJson());

class SearchResponse {
  String query;
  String type;
  int count;
  List<SearchItem> results;

  SearchResponse({
    required this.query,
    required this.type,
    required this.count,
    required this.results,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final resultsKey = json["type"];
    final rawResults = json[resultsKey] ?? [];

    return SearchResponse(
      query: json["query"],
      type: json["type"],
      count: json["count"],
      results: List<SearchItem>.from(
        rawResults.map((x) => SearchItem.fromJson(x, json["type"])),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final resultsKey = type;
    return {
      "query": query,
      "type": type,
      "count": count,
      resultsKey: List<dynamic>.from(results.map((x) => x.toJson())),
    };
  }
}

class SearchItem {
  String id;
  String title;
  String? subtitle;
  String? imageUrl;
  String category;
  Map<String, dynamic>? extra;

  SearchItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.category,
    this.extra,
  });

  factory SearchItem.fromJson(Map<String, dynamic> json, String category) {
    if (category == "players") {
      return SearchItem(
        id: json["id"].toString(),
        title: json["nama"],
        subtitle: json["posisi"],
        imageUrl: json["image_url"],
        category: category,
        extra: json,
      );
    }

    if (category == "clubs") {
      return SearchItem(
        id: json["id"].toString(),
        title: json["nama"],
        subtitle: json["negara"],
        imageUrl: json["image_url"],
        category: category,
        extra: json,
      );
    }

    return SearchItem(
      id: json["id"].toString(),
      title: json["nama_event"],
      subtitle: json["lokasi"] ?? "",
      imageUrl: json["image_url"],
      category: category,
      extra: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "image_url": imageUrl,
        "category": category,
        "extra": extra,
      };
}
