import 'package:flutter/material.dart';

class BulletList extends StatelessWidget {
  final List strings;
   final Widget bullet;

   BulletList(this.strings, this.bullet, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: strings.map((str) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               bullet,
              const SizedBox(
                width: 11,
              ),
              Expanded(
                child: Text(
                  str,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87
                  )
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}