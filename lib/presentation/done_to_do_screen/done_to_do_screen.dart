import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../common/components/custom_text.dart';
import '../../common/components/dimension.dart';
import '../../core/providers/todo_provider.dart';

class DoneToDoScreen extends StatefulWidget {
  const DoneToDoScreen({super.key});

  @override
  State<DoneToDoScreen> createState() => _DoneToDoScreenState();
}

class _DoneToDoScreenState extends State<DoneToDoScreen> {
  final List<Todo> _todos = [];

  final Map<String, List<Todo>> _categorizedTodos = {};

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Load todos from your data here
    _categorizeTodos();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            60.verticalSpace,
            Align(
              alignment: const Alignment(0, 0.5),
              child: CustomText(
                requiredText: 'Done To-do',
                fontSize: MyDimension.dim16,
                fontWeight: FontWeight.w500,
              ),
            ),
            25.horizontalSpace,
            Visibility(
              visible: _categorizedTodos.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: _categorizedTodos.length,
                  itemBuilder: (context, index) {
                    final categories = _categorizedTodos.keys.toList();
                    final category = categories[index];
                    final todos = _categorizedTodos[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(category),
                          ],
                        ), // Display the category (e.g., 'Today', 'Yesterday', or date)

                        SizedBox(
                          height: 5.h,
                        ),
                        for (final todo in todos)
                          Column(
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
                                            color: Colors.grey.shade600,
                                            requiredText: todo.name,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            textDecoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  const Icon(
                                    CupertinoIcons.right_chevron,
                                    size: 15,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                            ],
                          ),
                        const Divider(
                          color: Color(0xFFEBEAEA),
                          thickness: 1.5,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Center(
                child: Visibility(
              visible: _categorizedTodos.isEmpty,
              child: const CustomText(
                requiredText: 'No to-do yet',
                color: Colors.black,
              ),
            )),
            40.verticalSpace,
          ],
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
