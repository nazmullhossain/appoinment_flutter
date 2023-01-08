import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllProviders extends StatelessWidget {
  const AllProviders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          FutureBuilder(
            builder: (BuildContext context, future) {
              if (!future.hasData) {
                return const Center(
                  child: Text('No provider list found'),
                );
              } else {
                var list = future.data;
                return ListView.separated(
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    const Text('list.name'),
                                    readStar(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 130,
                                  width: 80,
                                  child: Image(
                                    image: NetworkImage('list.imageUrl'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Make an Appointment'),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, _) => const SizedBox(
                    height: 5,
                  ),
                  itemCount: 7,
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget readStar() => RatingBarIndicator(
        itemBuilder: (context, _) => const Icon(
          Icons.star_border_rounded,
          color: Colors.amber,
        ),
        // onRatingUpdate: (rating) {},
        // allowHalfRating: true,
        // updateOnDrag: false,
        // ignoreGestures: true,
        // minRating: 1,
        // maxRating: 5,
        unratedColor: Colors.grey,
        direction: Axis.horizontal,
        itemSize: 25,
      );
}
