import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class TodoAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TodoAppbar({
    super.key,
     this.ontap,
  });
  final void Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: InkWell(
          onTap: ontap,
          child: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/profile.png'),
                fit: BoxFit.fill
                )
            ),
          )
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, Samuel I.',
            style: TextStyle(
            ),
          ),
          Text(
            'What do you have planned',
            // style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset('assets/icons/Notification.svg'),
        )
      ],
    );
  }
 @override
  Size get preferredSize =>  const Size.fromHeight(kToolbarHeight);
}
