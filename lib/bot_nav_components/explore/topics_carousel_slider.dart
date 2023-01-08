import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class TopicsCarousel extends StatefulWidget {
  @override
  State<TopicsCarousel> createState() => _TopicsCarouselState();
}

class _TopicsCarouselState extends State<TopicsCarousel> {
  int activeIndex = 0;
  final images = [
    'assets/images/carousel/home-decor-1.jpg',
    'assets/images/carousel/home-decor-2.jpg',
    'assets/images/carousel/art-pencil-1.jpg',
  ];

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        final image = images[index];

        return buildImage(image, index);
      },
      options: CarouselOptions(
        height: height * 0.222,
        viewportFraction: 1.0,
        // aspectRatio: 16 / 9,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        onPageChanged: (index, reason) {
          setState(() {
            activeIndex = index;
          });
        },
        scrollDirection: Axis.horizontal,
        enlargeCenterPage: true,
      ),
    );
  }

  Widget buildImage(String image, int index) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.outline,
          ),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
      );
}
