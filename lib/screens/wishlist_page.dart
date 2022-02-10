import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWishlistData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: items.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your wishlist has ${items.length} item(s)',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Expanded(
                        child: ListView.separated(
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(right: 8),
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 120,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16)),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(4),
                                child: Image.network(items[index]['image']),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          items[index]['title'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        CloseButton(
                                          onPressed: () {
                                            removeItemFromWishlist(index);
                                          },
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'item: ${items[index]['catagory']}',
                                        style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${items[index]['quantity']}',
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 18,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '৳ ${items[index]['price']}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        MaterialButton(
                                          color: const Color(0xff880061),
                                          shape: const StadiumBorder(),
                                          onPressed: () async {
                                            addToCart(index);
                                          },
                                          child: const Text(
                                            'Add to Cart',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: items.length,
                    ))
                  ],
                ),
        ),
      ),
    );
  }

  getWishlistData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var cartData = await firestore.collection('whish-list').get();

    for (var doc in cartData.docs) {
      setState(() {
        Map map = {
          'title': doc['title'],
          'catagory': doc['catagory'],
          'image': doc['image'],
          'price': doc['price'],
          'description': doc['description'],
          'rating': doc['rating'],
          'id': doc.id,
          'quantity': doc['quantity']
        };
        items.add(map);
      });
      print(items);
    }
  }

  void addToCart(int index) {
    // int price = int.parse(widget.productDetails['price'] * quantity);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore.collection('users-cart').add({
      'catagory': items[index]['catagory'],
      'description': items[index]['description'],
      'image': items[index]['image'],
      'price': items[index]['price'],
      'rating': items[index]['rating'],
      'title': items[index]['title'],
      'quantity': items[index]['quantity']
    });
    showMessage(msg: "Successfully added to cart");
  }

  showMessage({required String msg}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(msg),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('ok'))
            ],
          );
        });
  }

  void removeItemFromWishlist(int index) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('whish-list').doc(items[index]['id']).delete();
    items.clear();
    getWishlistData();
    setState(() {});
  }
}
