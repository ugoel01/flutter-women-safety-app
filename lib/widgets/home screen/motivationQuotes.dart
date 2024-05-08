import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_women_safety_app/utils/quotes.dart';

class MotivationQuotes extends StatelessWidget {
  const MotivationQuotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 80,
      child: CarouselSlider(
        items: List.generate(
          motivationalQuotesimg.length, (index) => Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(motivationalQuotesimg[index])
                  )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [Colors.black.withOpacity(0.5),Colors.transparent])),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(motivationalQuotes[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width * 0.04
                            ),),
                          ),
                    )
                  )
            )
          )),
        options: CarouselOptions(
          aspectRatio: 2.0,
          autoPlay: true,
          enlargeCenterPage: true
        )),
    );
  }
}