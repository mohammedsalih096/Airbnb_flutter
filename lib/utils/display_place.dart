import 'package:airbnb_app/provider/favourite_provider.dart';
import 'package:airbnb_app/view/place_detail_screen.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DisplayPlace extends StatefulWidget {
  const DisplayPlace({super.key});

  @override
  State<DisplayPlace> createState() => _DisplayPlaceState();
}

class _DisplayPlaceState extends State<DisplayPlace> {
  // Firestore collection reference
  final CollectionReference placeCollection =
      FirebaseFirestore.instance.collection("myAppCollection");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  final provider = FavoriteProvider.of(context);
    return StreamBuilder(
      stream: placeCollection.snapshots(),
      builder: (context, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerEffect(size);
        }

        if (!streamSnapshot.hasData || streamSnapshot.data!.docs.isEmpty) {
          return buildShimmerEffect(size);
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: streamSnapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final place = streamSnapshot.data!.docs[index];
            final placeData = place.data() as Map<String, dynamic>? ?? {};

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(place: place),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: buildImageCarousel(placeData),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          left: 15,
                          right: 15,
                          child: Row(
                            children: [
                              placeData['isActive'] == true
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        child: Text(
                                          "Guest Favorite",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(width: size.width * 0.03),
                              const Spacer(),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.favorite_outline_rounded,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        provider.toggleFavorite(place);
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: provider.isExist(place)
                                            ? Colors.red
                                            : Colors.black54,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        vendorProfile(placeData),
                      ],
                    ),
                    SizedBox(height: size.height * 0.01),
                    Row(
                      children: [
                        Text(
                          placeData['address'] ?? "Unknown Address",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 5),
                        Text(placeData['rating']?.toString() ?? "N/A"),
                      ],
                    ),
                    Text(
                      "Stay with ${placeData['vendor'] ?? "Unknown"} . ${placeData['vendorProfession'] ?? "Host"}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      placeData['date'] ?? "No date available",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: size.height * 0.007),
                    RichText(
                      text: TextSpan(
                        text: "\$${placeData['price'] ?? "0"} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        children: const [
                          TextSpan(
                            text: "per night",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildShimmerEffect(Size size) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds image carousel or fallback UI
  Widget buildImageCarousel(Map<String, dynamic> placeData) {
    final List<dynamic>? imageUrls = placeData['imageUrls'];

    if (imageUrls != null && imageUrls.isNotEmpty) {
      return AnotherCarousel(
        images: imageUrls.map((url) => NetworkImage(url.toString())).toList(),
        dotSize: 6,
        indicatorBgPadding: 5,
        dotBgColor: Colors.transparent,
        autoplay: true,
        showIndicator: imageUrls.length > 1,
      );
    } else {
      return Container(
        height: 300,
        width: double.infinity,
        color: Colors.grey[300],
        child: const Center(
          child: Text(
            "No images available",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      );
    }
  }

  /// Builds vendor profile UI
  Positioned vendorProfile(Map<String, dynamic> placeData) {
    return Positioned(
      bottom: 11,
      left: 10,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Image.asset(
              "assets/images/book_cover.png",
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              backgroundImage: placeData['vendorProfile'] != null
                  ? NetworkImage(placeData['vendorProfile'])
                  : const AssetImage("assets/images/default_avatar.png")
                      as ImageProvider,
            ),
          ),
        ],
      ),
    );
  }
}
