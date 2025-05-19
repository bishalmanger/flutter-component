import 'package:flutter/material.dart';

import '../helper/size_config.dart';

Widget dataDisplayStructure({
  required String key,
  required String value,
  required bool emptyCheckStatus,
  required BuildContext context,
  required double screenWidth,
  Color? textColor,
  TextButton? button,
}) {
  return Container(
    margin: const EdgeInsets.only(
      top: 10,
    ),
    width: screenWidth * 1,
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: getWidthForPercentage(35),
        child: Text(
          key,
          style: TextStyle(
              fontSize: getResponsiveFontSize(context, 22),
              fontWeight: FontWeight.bold,
              color: textColor??Colors.black
          ),
        ),
      ),
      SizedBox(
        width: getWidthForPercentage(5),
        child: Text(':',
            style: TextStyle(
                fontSize: getResponsiveFontSize(context, 22),
                fontWeight: FontWeight.bold,
                color: textColor??Colors.black
            )),
      ),
      Expanded(
        flex: 2,
        child: SizedBox(
            width: getWidthForPercentage(55),
            child: button ??
                (!emptyCheckStatus
                    ? Text(
                        value,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 22),
                            color: textColor??Colors.black
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(context, 22),
                            color: textColor??Colors.black
                        ),
                      ))),
      ),
    ]),
  );
}
