import 'package:flutter/material.dart';
import 'package:github_search/api.dart';
import 'package:github_search/repo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Repo> _repos;

  @override
  void initState() {
    super.initState();
    loadTrendingRepos();
  }

  void loadTrendingRepos() async {
    final repos = await Api.getTrendingRepositories();
    setState(() {
      this._repos = repos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            margin: EdgeInsets.only(top: 4.0),
            child: Column(
              children: <Widget>[
                Text('Github Repos',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline
                        .apply(color: Colors.white)),
                Text('Trending',
                    style: Theme
                        .of(context)
                        .textTheme
                        .subhead
                        .apply(color: Colors.white))
              ],
            )),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    if (_repos == null) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            'No Repositories',
            style: Theme.of(context).textTheme.headline,
          ));
    } else {
      return ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemCount: _repos.length,
          itemBuilder: (BuildContext context, int index) {
            return GithubItem(_repos[index]);
          });
    }
  }
}

class GithubItem extends StatelessWidget {
  final Repo repo;

  GithubItem(this.repo);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          onTap: () {
            _launchURL(repo.htmlUrl);
          },
          highlightColor: Colors.lightBlueAccent,
          splashColor: Colors.red,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text((repo.name != null) ? repo.name : '-',
                      style: Theme.of(context).textTheme.subhead),
                  Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                        repo.description != null
                            ? repo.description
                            : 'No desription',
                        style: Theme.of(context).textTheme.body1),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text((repo.owner != null) ? repo.owner : '',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.caption)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.0),
                                child: Text(
                                    (repo.watchersCount != null)
                                        ? '${repo.watchersCount} '
                                        : '0 ',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.caption),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Text(
                                (repo.language != null) ? repo.language : '',
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.caption)),
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
