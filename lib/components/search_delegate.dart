import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List<String> toSearchList;

  Search(this.toSearchList);

  List<String> recentList = ["텍스트 4", "텍스트 3"]; // 최근 검색목록.

  @override
  List<Widget> buildActions(BuildContext context) {
    // 취소버튼
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 뒤로가기 버튼
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, query); // pop과 비슷한 느낌. 결과인 query를 갖고 나갈 수 있다.
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 입력 후(키보드 자판에서 검색버튼을 눌렀을 때)에 빌드되는 리스트
    List<String> resultList = [];

    resultList = (toSearchList.where(
      (inputText) => inputText.contains(query),
    )).toList();

    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            resultList[index],
          ),
          leading: SizedBox(),
          onTap: () {
            query = resultList[index];
            close(context, query);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 입력 중에 빌드되는 추천리스트
    List<String> suggestionList = [];

    query.isEmpty
        ? suggestionList = recentList //In the true case. 최근 검색목록을 가져옴.
        : suggestionList = (toSearchList.where(
            // In the false case

            (inputText) => inputText.contains(query),
          )).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: () {
            query = suggestionList[index];
            close(context, query);
          },
        );
      },
    );
  }
}
