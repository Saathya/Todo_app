import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Models/user_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int currentpage = 2;
  List<Users> user = [];
  bool? isLoading = false;

  int totalPages = 0;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  Future<bool> getUserData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentpage = 1;
    } else {
      if (currentpage >= totalPages) {
        refreshController.loadNoData();
        return false;
      }
    }

    //fetch dta from http
    final Uri uri = Uri.parse("https://reqres.in/api/users?page=$currentpage");
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final item = userDataFromJson(response.body);

      if (isRefresh) {
        user = item.data!;
      } else {
        user.addAll(item.data!);
      }

      currentpage++;

      totalPages = item.totalPages!;

      // ignore: avoid_print
      print(response.body);
      setState(() {
        isLoading = false;
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listing Users"),
        centerTitle: true,
      ),
      body: getbody(),
    );
  }

  Widget getbody() {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      onRefresh: () async {
        final result = await getUserData(isRefresh: true);
        if (result) {
          refreshController.refreshCompleted();
        } else {
          refreshController.refreshFailed();
        }
      },
      onLoading: () async {
        final result = await getUserData();
        if (result) {
          refreshController.loadComplete();
        } else {
          refreshController.loadFailed();
        }
      },
      child: ListView.builder(
        itemBuilder: (context, index) {
          return getCard(user[index]);
        },
        itemCount: user.length,
      ),
    );
  }

  Widget getCard(Users user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: DecorationImage(
                        image: NetworkImage(user.avatar.toString()),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName!} ${user.lastName}".toString(),
                    style: const TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
