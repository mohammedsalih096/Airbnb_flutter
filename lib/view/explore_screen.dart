import 'package:airbnb_app/utils/display_place.dart';
import 'package:airbnb_app/utils/display_total_price.dart';
// import 'package:airbnb_app/utils/map_with_custome_info_window.dart';
import 'package:airbnb_app/utils/search_bar_and_filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final CollectionReference categoryColloction =
      FirebaseFirestore.instance.collection("AppCategory");

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            SearchBarAndFilter(),
            listOfCategoryItems(size),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [DisplayTotalPrice(), SizedBox(height: 10), DisplayPlace()],
              ),
            )),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> listOfCategoryItems(Size size) {
    return StreamBuilder(
      stream: categoryColloction.snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerEffect(size);
        }

        if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
          return buildShimmerEffect(size);
        }

        int itemCount = streamSnapshot.data!.docs.length;

        return Stack(
          children: [
            const Positioned(
              left: 0,
              right: 0,
              top: 80,
              child: Divider(
                color: Colors.black12,
              ),
            ),
            SizedBox(
              height: size.height * 0.12,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                physics: itemCount <= 8
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var doc = streamSnapshot.data!.docs[index];
                  var data = doc.data() as Map<String, dynamic>;

                  String imageUrl = data.containsKey('image') ? data['image'] : '';
                  String title = data.containsKey('title') ? data['title'] : 'No Title';
                  bool isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      if (selectedIndex != index) {
                        setState(() {
                          selectedIndex = index;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 20,
                        right: 20,
                        left: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 32,
                            width: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    color: isSelected ? Colors.black : Colors.black45,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image_not_supported);
                                    },
                                  )
                                : const Icon(Icons.image_not_supported),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? Colors.black : Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 3,
                            width: 50,
                            color: isSelected ? Colors.black : Colors.transparent,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildShimmerEffect(Size size) {
    return SizedBox(
      height: size.height * 0.12,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 15,
                    width: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 3,
                    width: 50,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
