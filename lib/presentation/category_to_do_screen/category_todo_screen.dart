import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common/components/custom_text.dart';
import '../../common/components/dimension.dart';
import '../../core/providers/todo_provider.dart';
import '../../data/shared_preferences/shared_preferences.dart';

class CategoryToDoScreen extends StatefulWidget {
  final String category;
  const CategoryToDoScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryToDoScreen> createState() => _CategoryToDoScreenState();
}

class _CategoryToDoScreenState extends State<CategoryToDoScreen> {
  final List<Todo> _todos = [];

  final Map<String, List<Todo>> _categorizedTodos = {};
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> todoList = [];
  final List<Map<String, dynamic>> _doneTodoList = [];
  final List<int> _todoIndex = [];

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load todos from your data here
    _categorizeTodos();
    loadDatas();
  }

  Future<void> loadDatas() async {
    await SharedPreferencesManager.init();
    final getTodoList = SharedPreferencesManager.loadTodos('todos');
    final getDoneTodoList = SharedPreferencesManager.loadTodos('done');

    setState(() {
      for (int i = 0; i < getTodoList.length; i++) {
        if (getTodoList[i]['todoCategory'] == widget.category) {
          todoList.add(getTodoList[i]);
          _todoIndex.add(i);
        }
      }

      for (int i = 0; i < getDoneTodoList.length; i++) {
        if (getDoneTodoList[i]['todoCategory'] == widget.category) {
          _doneTodoList.add(getDoneTodoList[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final read = context.read<TodoNotifier>();
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.verticalSpace,
              Row(
                children: [
                  InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back)),
                  Expanded(
                    child: CustomText(
                      textAlign: TextAlign.center,
                      requiredText: widget.category.replaceAll('\n', ' '),
                      fontSize: MyDimension.dim16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              25.verticalSpace,
              CustomText(
                textAlign: TextAlign.center,
                requiredText: 'Upcoming',
                fontSize: MyDimension.dim16,
                fontWeight: FontWeight.w600,
              ),
              10.verticalSpace,
              Visibility(
                visible: todoList.isNotEmpty,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    final item = todoList[index];

                    return AnimatedOpacity(
                      opacity: !item['todoIsCompleted'] ? 1 : 0,
                      onEnd: () {},
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeInOut,
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 30.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          setState(() {
                                            item['todoIsCompleted'] =
                                                !item['todoIsCompleted'];
                                          });

                                          Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () {
                                            read.toggleTodoItemCheckState(
                                                _todoIndex[index]);
                                            context
                                                .read<TodoNotifier>()
                                                .removeDoneFromTodo(
                                                    _todoIndex[index]);
                                            setState(() {
                                              todoList.removeAt(index);
                                              _todoIndex.removeAt(index);
                                              _doneTodoList.add(item);
                                            });
                                          });
                                        },
                                        child: Image.asset(
                                          item['todoIsCompleted']
                                              ? 'assets/png/checked.png'
                                              : 'assets/png/unchecked.png',
                                          width: 25,
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      SizedBox(
                                        width: 180.w,
                                        child: CustomText(
                                          requiredText: item['todoName'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          textDecoration:
                                              item['todoIsCompleted']
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    children: [
                                      Text(item['todoTime'] ?? ''),
                                      10.horizontalSpace,
                                      const Icon(
                                        CupertinoIcons.right_chevron,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Color(0xFFEBEAEA),
                              thickness: 1.5,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Visibility(
                  visible: todoList.isEmpty,
                  child: CustomText(
                    textAlign: TextAlign.center,
                    requiredText: 'No To-do in this category',
                    fontSize: MyDimension.dim16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              40.verticalSpace,
              CustomText(
                textAlign: TextAlign.center,
                requiredText: 'Done',
                fontSize: MyDimension.dim16,
                fontWeight: FontWeight.w600,
              ),
              10.verticalSpace,
              Visibility(
                visible: _doneTodoList.isNotEmpty,
                child: Expanded(
                  child: ListView.builder(
                    itemCount: _doneTodoList.length,
                    itemBuilder: (context, index) {
                      final item = _doneTodoList[index];

                      return AnimatedOpacity(
                        opacity: 1,
                        onEnd: () {},
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        child: SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 30.h,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/png/checked.png',
                                          width: 25,
                                        ),
                                        10.horizontalSpace,
                                        SizedBox(
                                          width: 180.w,
                                          child: CustomText(
                                            requiredText:
                                                item['todoName'] ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            textDecoration:
                                                item['todoIsCompleted']
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Text(item['todoTime'] ?? ''),
                                        10.horizontalSpace,
                                        const Icon(
                                          CupertinoIcons.right_chevron,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color(0xFFEBEAEA),
                                thickness: 1.5,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: Visibility(
                  visible: _doneTodoList.isEmpty,
                  child: CustomText(
                    textAlign: TextAlign.center,
                    requiredText: 'No To-do in this category',
                    fontSize: MyDimension.dim16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadTodos() {
    for (var todoData in context.read<TodoNotifier>().doneTodoList) {
      final String todoName = todoData['todoName'];
      final DateTime todoFullDate = DateTime.parse(todoData['todoFullDate']);
      final todo = Todo(todoName, todoFullDate);
      _todos.add(todo);
    }
    _todos.sort((a, b) => b.date.compareTo(a.date));
  }

  void _categorizeTodos() {
    for (var todo in _todos) {
      String category = _getCategory(todo.date);
      _categorizedTodos.putIfAbsent(category, () => []).add(todo);
    }
  }

  String _getCategory(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    if (date.isAfter(todayStart)) {
      return "Today";
    } else if (date.isAfter(yesterdayStart)) {
      return "Yesterday";
    } else {
      return _formatDate(date);
    }
  }

  String _formatDate(DateTime date) {
    // Format the date to 'EEEE d, MMMM yyyy' e.g., 'Sunday 15, May 2023'
    final day = date.day;
    final month = date.month;
    final year = date.year;
    return DateFormat('EEEE d, MMMM yyyy').format(DateTime(year, month, day));
  }
}

class Todo {
  final String name;
  final DateTime date;

  Todo(this.name, this.date);
}
