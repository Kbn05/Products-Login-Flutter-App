import 'dart:convert';
import 'package:jwt_app/database/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_app/widgets/homeList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_app/widgets/homeGrid.dart';
import 'package:get/get.dart';

class FavsView extends StatefulWidget {
  const FavsView({super.key});

  @override
  State<FavsView> createState() => _HomeViewState();
}

class _HomeViewState extends State<FavsView> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isGrid = false;

  @override
  void initState() {
    super.initState();
    viewMode();
    // fetchProducts();
  }

  // Future<List> fetchProducts() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final token = prefs.getString('token');
  //   final response = await http
  //       .get(Uri.parse('http://192.168.20.20:3000/products/fav'), headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //   });
  //   if (response.statusCode == 200) {
  //     var jsonResponse = jsonDecode(response.body);
  //     print('Response: $jsonResponse');
  //     print(jsonResponse.runtimeType);
  //     return jsonResponse;
  //   } else {
  //     throw Exception('Failed to load data');
  //   }
  // }

  Future<List> fetchProducts() async {
    final jsonProds = await DbHelper.productToJson();
    final products = jsonDecode(jsonProds);
    // print(jsonProds.runtimeType);
    // final products = jsonEncode(jsonProds);
    print(products.runtimeType);
    print('$products');
    return products;
  }

  Future<String> dropFav(String id) async {
    await DbHelper.deleteFavs(id);
    return 'Deleted';
  }

  Future<String> deleteFavs(String id) async {
    await dropFav(id);
    final SharedPreferences prefs = await _prefs;
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse('http://192.168.20.20:3000/products/fav'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'productId': id,
      }),
    );
    if (response.statusCode == 200) {
      print('Response: ${response.body}');
      return response.body;
    } else {
      throw Exception('Failed to delete data');
    }
  }

  void viewMode() {
    setState(() {
      _isGrid = !_isGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (_isGrid == true) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Home'),
    //       actions: [
    //         IconButton(
    //           icon: _isGrid
    //               ? const Icon(Icons.list)
    //               : const Icon(Icons.grid_view),
    //           onPressed: viewMode,
    //         ),
    //       ],
    //     ),
    //     body: FutureBuilder<List>(
    //       future: fetchProducts(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return GridView.count(
    //               crossAxisCount: 2,
    //               children: List.generate(snapshot.data!.length, (index) {
    //                 return HomeGrid(
    //                   image: snapshot.data![index]['image'],
    //                   name: snapshot.data![index]['name'],
    //                   owner: snapshot.data![index]['owner'],
    //                   rate: snapshot.data![index]['rate'].toString(),
    //                 );
    //               }));
    //         } else if (snapshot.hasError) {
    //           return Text('${snapshot.error}');
    //         }
    //         return const CircularProgressIndicator();
    //       },
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Home'),
    //       actions: [
    //         IconButton(
    //           icon: _isGrid
    //               ? const Icon(Icons.list)
    //               : const Icon(Icons.grid_view),
    //           onPressed: viewMode,
    //         ),
    //       ],
    //     ),
    //     body: FutureBuilder<List>(
    //       future: fetchProducts(),
    //       builder: (context, snapshot) {
    //         if (snapshot.hasData) {
    //           return ListView.builder(
    //             itemCount: snapshot.data!.length,
    //             itemBuilder: (context, index) {
    //               return HomeList(
    //                 image: snapshot.data![index]['image'],
    //                 name: snapshot.data![index]['name'],
    //                 owner: snapshot.data![index]['owner'],
    //                 rate: snapshot.data![index]['rate'].toString(),
    //               );
    //             },
    //           );
    //         } else if (snapshot.hasError) {
    //           return Text('${snapshot.error}');
    //         }
    //         return const CircularProgressIndicator();
    //       },
    //     ),
    //   );
    // }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon:
                _isGrid ? const Icon(Icons.list) : const Icon(Icons.grid_view),
            onPressed: viewMode,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final SharedPreferences prefs = await _prefs;
              prefs.remove('token');
              // final db = await DbHelper.database();
              await DbHelper.deleteProduct().then((value) => DbHelper.close());
              Get.offAllNamed('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<List>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_isGrid == true) {
              return GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 0.635,
                  children: List.generate(snapshot.data!.length, (index) {
                    return HomeGrid(
                      id: snapshot.data![index]['id'],
                      image: snapshot.data![index]['image'],
                      name: snapshot.data![index]['name'],
                      owner: snapshot.data![index]['owner'],
                      rate: snapshot.data![index]['rate'].toString(),
                      onPressed: () async {
                        await deleteFavs(snapshot.data![index]['id']);
                      },
                    );
                  }));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return HomeList(
                    id: snapshot.data![index]['id'],
                    image: snapshot.data![index]['image'],
                    name: snapshot.data![index]['name'],
                    owner: snapshot.data![index]['owner'],
                    rate: snapshot.data![index]['rate'].toString(),
                    onPressed: () async {
                      await deleteFavs(snapshot.data![index]['id']);
                    },
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
