import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(
              4,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4),
                    child: SizedBox(
                      height: 160.0,
                      child: Shimmer.fromColors(
                        baseColor: Colors.black.withOpacity(0.4),
                        highlightColor: Colors.black.withOpacity(0.6),
                        child: Card(
                          child: ListTile(
                            dense: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: width * 0.4,
                                  child: Text(
                                    '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '',
                                      // textDirection: ui.TextDirection.ltr,
                                      style: TextStyle(fontFamily: "Arial"),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: width * 0.4,
                                  child: Text(
                                    '',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }
}
