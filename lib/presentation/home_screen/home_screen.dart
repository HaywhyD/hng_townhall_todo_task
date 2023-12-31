import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/common/constants/assets_constants.dart';
import 'package:to_do_app/presentation/done_to_do_screen/done_to_do_screen.dart';
import 'package:to_do_app/presentation/settings_screen/settings_screen.dart';
import '../../common/components/custom_focus_background.dart';
import '../../common/components/custom_text.dart';
import '../../common/components/dimension.dart';
import '../../common/components/search_bar.dart';
import '../../common/constants/app_color.dart';
import '../../common/constants/route_constant.dart';
import '../../core/config/router_config.dart';
import '../../core/providers/todo_provider.dart';
import '../../data/shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController(initialPage: 0);
  List<Map<String, dynamic>> categories = [];
  final DateTime _dateTime = DateTime.now();
  bool isTodayTodo = false;
  List<Map<String, dynamic>> gradient = [
    {
      'gradient': [const Color(0xFF88D2F5), const Color(0xFF0FA9F4)],
    },
    {
      'gradient': [const Color(0xFF7ED9D2), const Color(0xFF10CFB1)],
    },
    {
      'gradient': [const Color(0xFFFEBCA7), const Color(0xFFFD7E7E)],
    },
  ];
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> _overDueTodoList = [];
  List<Map<String, dynamic>> _doneTodoList = [];

  @override
  void initState() {
    super.initState();
    loadDatas();
  }

  Future<void> loadDatas() async {
    await SharedPreferencesManager.init();
    final getTodoList = SharedPreferencesManager.loadTodos('todos');
    final getDoneTodoList = SharedPreferencesManager.loadTodos('done');
    setState(() {
      _doneTodoList = getDoneTodoList;
    });
    final getCategories = SharedPreferencesManager.loadCategories();
    if (getTodoList.isNotEmpty) {
      setState(() {
        todoList = getTodoList;
      });

      toggleTodo(true, 0);
    } else {
      toggleTodo(false, 0);
    }
    if (getCategories.isNotEmpty) {
      setState(() {
        categories = getCategories;
      });
    } else {
      setState(() {
        categories = [
          {
            'text': 'Personal',
          },
          {
            'text': 'Work',
          },
          {
            'text': 'Books to\nread',
          },
        ];
      });
    }

    if (categories.length > 3) {
      List<List<Color>> gradients = [
        [const Color(0xFF88D2F5), const Color(0xFF0FA9F4)],
        [const Color(0xFF7ED9D2), const Color(0xFF10CFB1)],
        [const Color(0xFFFEBCA7), const Color(0xFFFD7E7E)],
      ];
      categories.map((category) {
        // Get a random gradient from the list of gradients
        final Random random = Random();
        final List<Color> randomGradient =
            gradients[random.nextInt(gradients.length)];
        gradient.add({
          'gradient': randomGradient,
        });
      }).toList();
    }
    checkTodos(getTodoList);
  }

  checkTodos(List<Map<String, dynamic>> getTodoList) {
    final getOverdueTodoList = SharedPreferencesManager.loadTodos('overdue');
    for (int i = 0; i < getTodoList.length; i++) {
      final int diff = _dateTime
          .difference(DateTime.parse(getTodoList[i]['todoFullDate']))
          .inMinutes;
      if (diff > 0) {
        setState(() {
          getOverdueTodoList.add(getTodoList[i]);
          todoList.removeAt(i);
        });
      }
    }
    setState(() {
      _overDueTodoList = getOverdueTodoList;
    });
    addTodo();
  }

  toggleTodo(bool show, int index) {
    context.read<TodoNotifier>().hideTodoList(show);
  }

  addTodo() {
    context.read<TodoNotifier>().addTodo(todoList);
    context.read<TodoNotifier>().addCategories(categories);
    context.read<TodoNotifier>().addOverDueTodo(_overDueTodoList);
    context.read<TodoNotifier>().addDoneTodo(_doneTodoList);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final todoNotifier = context.watch<TodoNotifier>();
    final watch = context.watch<TodoNotifier>();
    final read = context.read<TodoNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: RefreshIndicator(
            onRefresh: loadDatas,
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {},
              children: [
                Stack(
                  children: [
                    //main content
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: SizedBox(
                        width: mediaQuery.width,
                        height: mediaQuery.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            50.verticalSpace,
                            //user header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      Assets.userImage,
                                      width: 50.w,
                                    ),
                                    10.horizontalSpace,
                                    //greeting
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          requiredText: context
                                              .read<TodoNotifier>()
                                              .greetingText,
                                          fontSize: MyDimension.dim16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.textColor,
                                          textAlign: TextAlign.left,
                                        ),
                                        5.verticalSpace,
                                        CustomText(
                                          requiredText:
                                              'What do you have planned ',
                                          textAlign: TextAlign.left,
                                          fontSize: MyDimension.dim10,
                                          color: AppColor.textColor
                                              .withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //bell
                                Image.asset(
                                  Assets.bellImage,
                                  width: 28.w,
                                )
                              ],
                            ),
                            30.verticalSpace,
                            //search
                            CustomSearchBar(
                              controller:
                                  context.read<TodoNotifier>().searchController,
                              onTap: () {},
                            ),
                            30.verticalSpace,
                            //categories
                            SizedBox(
                              height: 67.h,
                              width: mediaQuery.width,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: watch.categories.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              InkWell(
                                                  onTap: () => context.push(
                                                        RoutesPath
                                                            .categoryScreen,
                                                        extra: {
                                                          "category": context
                                                                  .read<
                                                                      TodoNotifier>()
                                                                  .categories[
                                                              index]['text'],
                                                        },
                                                      ),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                    decoration: ShapeDecoration(
                                                      gradient: LinearGradient(
                                                        begin: const Alignment(
                                                            0.00, -1.00),
                                                        end: const Alignment(
                                                            0, 1),
                                                        colors: gradient[index]
                                                            ['gradient'],
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    constraints: BoxConstraints(
                                                      minWidth: 120.w,
                                                      maxWidth: 120.w,
                                                      minHeight: 67.h,
                                                      maxHeight: 67.h,
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          child: CustomText(
                                                            requiredText: context
                                                                    .read<
                                                                        TodoNotifier>()
                                                                    .categories[
                                                                index]['text'],
                                                            fontSize:
                                                                MyDimension
                                                                    .dim12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            softWrap: true,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              20.horizontalSpace,
                                            ],
                                          );
                                        }),
                                    Container(
                                      height: 67.h,
                                      width: mediaQuery.width,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      constraints: BoxConstraints(
                                        minWidth: 140.w,
                                        maxWidth: 140.w,
                                        minHeight: 67.h,
                                        maxHeight: 67.h,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey.shade200,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            CupertinoIcons.plus,
                                            color: AppColor.textColor,
                                          ),
                                          Flexible(
                                            child: CustomText(
                                              requiredText: 'Add Categories',
                                              fontSize: MyDimension.dim12,
                                              color: const Color(0xFF192028),
                                              fontWeight: FontWeight.w500,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            30.verticalSpace,
                            //upcoming to dos
                            GestureDetector(
                              onTap: () => context
                                  .read<TodoNotifier>()
                                  .toggleListVisibility(),
                              child: Container(
                                width: double.infinity,
                                height: 41.h,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 10.h,
                                ),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Upcoming To-do\'s',
                                          style: GoogleFonts.roboto(
                                            color: const Color(0xFF192028),
                                            fontSize: MyDimension.dim16,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        10.horizontalSpace,
                                        Container(
                                          width: 25.w,
                                          height: 25.h,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFFF4C4C),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          child: Text(
                                            "${watch.todoList.length}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: MyDimension.dim10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //down arrow
                                    SizedBox(
                                      width: 16.w,
                                      height: 16.h,
                                      child: Icon(todoNotifier.isListVisible
                                          ? CupertinoIcons.chevron_down
                                          : CupertinoIcons.chevron_up),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //list
                            if (todoNotifier.isListVisible)
                              AnimatedOpacity(
                                opacity: todoNotifier.isListVisible ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 800),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    bottom: 20.h,
                                  ),
                                  child: watch.isListVisible
                                      ? context
                                              .watch<TodoNotifier>()
                                              .todoList
                                              .isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: context
                                                  .watch<TodoNotifier>()
                                                  .todoList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final item = context
                                                    .read<TodoNotifier>()
                                                    .todoList[index];

                                                return AnimatedOpacity(
                                                  opacity:
                                                      !item['todoIsCompleted']
                                                          ? 1
                                                          : 0,
                                                  onEnd: () {},
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.easeInOut,
                                                  child: SizedBox(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: 30.h,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      read.toggleTodoItemCheckState(
                                                                          index);
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 1000),
                                                                          () {
                                                                        context
                                                                            .read<TodoNotifier>()
                                                                            .removeDoneFromTodo(index);
                                                                      });
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      item['todoIsCompleted']
                                                                          ? 'assets/png/checked.png'
                                                                          : 'assets/png/unchecked.png',
                                                                      width: 25,
                                                                    ),
                                                                  ),
                                                                  10.horizontalSpace,
                                                                  SizedBox(
                                                                    width:
                                                                        180.w,
                                                                    child:
                                                                        CustomText(
                                                                      requiredText:
                                                                          item['todoName'] ??
                                                                              '',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          true,
                                                                      textDecoration: item[
                                                                              'todoIsCompleted']
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : TextDecoration
                                                                              .none,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: Row(
                                                                children: [
                                                                  Text(item[
                                                                          'todoTime'] ??
                                                                      ''),
                                                                  10.horizontalSpace,
                                                                  const Icon(
                                                                    CupertinoIcons
                                                                        .right_chevron,
                                                                    size: 15,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          color:
                                                              Color(0xFFEBEAEA),
                                                          thickness: 1.5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : const Center(
                                              child: Text('No todos yet'),
                                            )
                                      : const SizedBox(),
                                ),
                              ),

                            20.verticalSpace,
                            //overdue
                            GestureDetector(
                              onTap: () => context
                                  .read<TodoNotifier>()
                                  .toggleOverdueVisibility(),
                              child: Container(
                                width: double.infinity,
                                height: 41.h,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //overdue
                                        Text(
                                          'Overdue',
                                          style: GoogleFonts.roboto(
                                            color: const Color(0xFF192028),
                                            fontSize: MyDimension.dim16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        10.horizontalSpace,

                                        //alert
                                        Container(
                                          width: 25.w,
                                          height: 25.h,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFFFF4C4C),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                          child: Text(
                                            "${watch.overdueTodoList.length}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: MyDimension.dim10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.horizontalSpace,
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Icon(todoNotifier.isOverdue
                                          ? CupertinoIcons.chevron_down
                                          : CupertinoIcons.chevron_up),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            //list
                            if (todoNotifier.isOverdue)
                              AnimatedOpacity(
                                opacity: todoNotifier.isOverdue ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 800),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    bottom: 20.h,
                                  ),
                                  child: watch.isOverdue
                                      ? context
                                              .watch<TodoNotifier>()
                                              .overdueTodoList
                                              .isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: context
                                                  .watch<TodoNotifier>()
                                                  .overdueTodoList
                                                  .length,
                                              itemBuilder: (context, index) {
                                                final item = context
                                                    .read<TodoNotifier>()
                                                    .overdueTodoList[index];

                                                return AnimatedOpacity(
                                                  opacity:
                                                      !item['todoIsCompleted']
                                                          ? 1
                                                          : 0,
                                                  onEnd: () {},
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves.easeInOut,
                                                  child: SizedBox(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              height: 30.h,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      read.toggleOverdueTodoItemCheckState(
                                                                          index);
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 1000),
                                                                          () {
                                                                        context
                                                                            .read<TodoNotifier>()
                                                                            .removeDoneFromOverdueTodo(index);
                                                                      });
                                                                    },
                                                                    child: Image
                                                                        .asset(
                                                                      item['todoIsCompleted']
                                                                          ? 'assets/png/checked.png'
                                                                          : 'assets/png/unchecked.png',
                                                                      width: 25,
                                                                    ),
                                                                  ),
                                                                  10.horizontalSpace,
                                                                  SizedBox(
                                                                    width:
                                                                        180.w,
                                                                    child:
                                                                        CustomText(
                                                                      requiredText:
                                                                          item['todoName'] ??
                                                                              '',
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          true,
                                                                      textDecoration: item[
                                                                              'todoIsCompleted']
                                                                          ? TextDecoration
                                                                              .lineThrough
                                                                          : TextDecoration
                                                                              .none,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                              child: Row(
                                                                children: [
                                                                  Text(item[
                                                                          'todoTime'] ??
                                                                      ''),
                                                                  10.horizontalSpace,
                                                                  const Icon(
                                                                    CupertinoIcons
                                                                        .right_chevron,
                                                                    size: 15,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          color:
                                                              Color(0xFFEBEAEA),
                                                          thickness: 1.5,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : const Center(
                                              child: Text('No todos yet'),
                                            )
                                      : const SizedBox(),
                                ),
                              ),

                            //notes
                            20.verticalSpace,
                            GestureDetector(
                              onTap: () => context
                                  .read<TodoNotifier>()
                                  .toggleNotesVisibility(),
                              child: Container(
                                width: double.infinity,
                                height: 41.h,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Notes',
                                      style: GoogleFonts.roboto(
                                        color: const Color(0xFF192028),
                                        fontSize: MyDimension.dim16,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Icon(todoNotifier.isNotes
                                          ? CupertinoIcons.chevron_down
                                          : CupertinoIcons.chevron_up),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (todoNotifier.isFloatingPressed)
                      CustomFocusBackground(mediaQuery: mediaQuery),
                    //add to do
                    if (todoNotifier.isFloatingPressed)
                      AnimatedPositioned(
                        curve: Curves.easeInOut,
                        bottom: 195,
                        right: 40,
                        duration: const Duration(milliseconds: 2000),
                        child: GestureDetector(
                          onTap: () {
                            routerConfig.push(RoutesPath.addTodoScreen);
                            context.read<TodoNotifier>().toggleFloatButton();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.easeInOut,
                            width: 129,
                            height: 41,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFF8C22),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/png/add_to_do.png',
                                  width: 15,
                                ),
                                10.horizontalSpace,
                                Text(
                                  'Add To-do',
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    //add notes
                    if (todoNotifier.isFloatingPressed)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 2000),
                        curve: Curves.easeInOut,
                        bottom: 140,
                        right: 40,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.easeInOut,
                          width: 129,
                          height: 41,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF51526B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/png/add_to_do.png',
                                width: 15,
                              ),
                              10.horizontalSpace,
                              Text(
                                'Add Note',
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const DoneToDoScreen(),
                const SettingsScreen(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                size: 30,
                color: todoNotifier.navIndex == 0
                    ? AppColor.appColor
                    : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined,
                size: 30,
                color: todoNotifier.navIndex == 1
                    ? AppColor.appColor
                    : Colors.grey),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                size: 30,
                color: todoNotifier.navIndex == 2
                    ? AppColor.appColor
                    : Colors.grey),
            label: 'Settings',
          ),
        ],
        currentIndex: watch.navIndex,
        onTap: (index) async {
          context.read<TodoNotifier>().setNavIndex(index);
          _controller.jumpToPage(index);
        },
        selectedLabelStyle: GoogleFonts.roboto(color: AppColor.appColor),
        unselectedLabelStyle: GoogleFonts.roboto(color: Colors.grey),
        selectedItemColor: AppColor.appColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TodoNotifier>().toggleFloatButton(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: todoNotifier.isFloatingPressed
            ? const Color(0xFF645A50)
            : AppColor.appColor,
        child: Icon(
          todoNotifier.isFloatingPressed ? CupertinoIcons.xmark : Icons.add,
          color: Colors.white,
        ), // Customize the button color.
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
