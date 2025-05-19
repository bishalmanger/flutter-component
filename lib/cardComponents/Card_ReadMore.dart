import 'package:cc21_customer/helpers/constants.dart';
import 'package:flutter/material.dart';

class NotificationShowComponent extends StatelessWidget {
  final String recordId;
  final String notificationId;
  final String orderDiscription;
  final String orderStatus;
  final Color? color;
  final String dateTime;
  final bool isExpanded;
  final VoidCallback onExpand;

  const NotificationShowComponent(
      this.recordId,
      this.notificationId,
      this.orderDiscription,
      this.orderStatus,
      this.color,
      this.dateTime, {
        required this.isExpanded,
        required this.onExpand,
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      color: const Color(0xffD9D9D9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints){
            const textStyle = TextStyle(fontSize: 14);
            final lineCount = getLineCount(orderDiscription, constraints.maxWidth, textStyle);
            final shouldShowReadMore = lineCount > 2;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notificationId.isNotEmpty ? notificationId : orderStatus,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (orderStatus.isNotEmpty && notificationId.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: color ?? kPrimaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          orderStatus,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 8),
                shouldShowReadMore
                    ? GestureDetector(
                  onTap: onExpand,
                  child: Stack(
                    children: [
                      isExpanded
                          ? Text(orderDiscription, style: textStyle, textAlign: TextAlign.start,)
                          : Text(
                        orderDiscription.substring(0, 89),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle,
                        textAlign: TextAlign.justify,
                      ),
                      if (!isExpanded)
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: Text(
                            "...Read More",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                          ),
                        ),
                    ],
                  ),
                )
                    : Text(orderDiscription, style: textStyle),
                if (dateTime.isNotEmpty)
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(dateTime, style: const TextStyle(fontSize: 10)),
                  ),
              ],
            );
          },
        ),
      ),
    );

  }
  int getLineCount(String text, double maxWidth, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    return tp.computeLineMetrics().length;
  }
}
