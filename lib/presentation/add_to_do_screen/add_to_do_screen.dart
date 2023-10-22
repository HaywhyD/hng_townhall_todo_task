import 'package:datetime_picker_field_platform/datetime_picker_field_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_area/text_area.dart';
import 'package:to_do_app/common/constants/app_color.dart';
import 'package:to_do_app/data/models/todo_model.dart';
import 'package:to_do_app/data/shared_preferences/shared_preferences.dart';

import '../../common/components/custom_text.dart';
import '../../common/components/dimension.dart';
import '../../common/constants/route_constant.dart';
import '../../core/config/router_config.dart';
import '../../core/providers/todo_provider.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final additionalDetailController = TextEditingController();
  bool reasonValidation = true;
  final GlobalKey<FormState> addDetailsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> todoFormKey = GlobalKey<FormState>();
  final TextEditingController todoController = TextEditingController();
  final TextEditingController subTaskController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TodoModel _todoModel = TodoModel();
  String category = '';
  List<bool> isChecked = [];
  List<String> subTasks = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isChecked = List.generate(
          context.read<TodoNotifier>().categories.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final todoNotifier = context.watch<TodoNotifier>();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: mediaQuery.width,
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => routerConfig.pop(),
                        child: const Icon(CupertinoIcons.xmark)),
                    Align(
                      alignment: const Alignment(0, 0.5),
                      child: CustomText(
                        requiredText: 'Add To-do',
                        fontSize: MyDimension.dim16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    25.horizontalSpace,
                  ],
                ),
                40.verticalSpace,
                CustomText(
                  requiredText: 'To-do',
                  fontSize: MyDimension.dim12,
                  fontWeight: FontWeight.bold,
                ),
                10.verticalSpace,
                Form(
                  key: todoFormKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      } else {
                        return null;
                      }
                    },
                    controller: todoController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'What do you want to do',
                      hintStyle: GoogleFonts.roboto(
                        color: const Color(0xFFDEE1E4),
                        fontSize: MyDimension.dim22,
                        fontWeight: FontWeight.bold,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: AppColor.appColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                    ),
                  ),
                ),
                20.verticalSpace,
                //date
                const CustomText(requiredText: 'Date'),
                5.verticalSpace,
                DateTimeFieldPlatform(
                  mode: DateMode.date,
                  controller: dateController,
                  decoration: InputDecoration(
                    hintText: 'Select date',
                    hintStyle: GoogleFonts.roboto(
                        fontSize: MyDimension.dim10,
                        color: const Color(0xFFC6C1C1),
                        fontWeight: FontWeight.w400),
                    prefixIcon: const Icon(Icons.date_range),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xFF9BA1A9)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                  ),
                  maximumDate: DateTime.now().add(const Duration(days: 720)),
                  minimumDate: DateTime.utc(2009),
                  dateFormatter: 'EEEE d, MMMM',
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Select Date';
                    }
                    return null;
                  },
                ),
                25.verticalSpace,
                //time
                const CustomText(requiredText: 'Time'),
                5.verticalSpace,
                //time
                Padding(
                  padding: const EdgeInsets.only(right: 150),
                  child: DateTimeFieldPlatform(
                    mode: DateMode.time,
                    controller: timeController,
                    decoration: InputDecoration(
                      hintText: 'Select time',
                      hintStyle: GoogleFonts.roboto(
                          fontSize: MyDimension.dim10,
                          color: const Color(0xFFC6C1C1),
                          fontWeight: FontWeight.w400),
                      prefixIcon: const Icon(Icons.access_time),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 1, color: Color(0xFF9BA1A9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    maximumDate: DateTime.now().add(const Duration(hours: 2)),
                    minimumDate:
                        DateTime.now().subtract(const Duration(hours: 2)),
                    timeFormatter: 'h:mm a',
                    initialDate: DateTime.now(),
                  ),
                ),
                25.verticalSpace,
                //subtask
                const CustomText(requiredText: 'Sub-Task'),
                5.verticalSpace,
                // Display the sub-tasks using ListView.builder
                if (todoNotifier.isOneTempSubTask)
                  Consumer<TodoNotifier>(
                      builder: (context, todoNotifier, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: todoNotifier.tempSubTask.length,
                      itemBuilder: (context, index) {
                        String item = todoNotifier.tempSubTask[index];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(requiredText: item),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    5.horizontalSpace,
                                    GestureDetector(
                                      onTap: () {
                                        todoNotifier.removeSubTask(item);
                                        if (todoNotifier.tempSubTask.isEmpty) {
                                          todoNotifier
                                              .setIsOneTempSubTask(false);
                                          todoNotifier.setShowTaskField(false);
                                        }
                                      },
                                      child: CustomText(
                                        requiredText: 'Remove',
                                        color: Colors.red,
                                        fontSize: MyDimension.dim12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            10.verticalSpace
                          ],
                        );
                      },
                    );
                  }),
                if (!todoNotifier.isOneTempSubTask ||
                    todoNotifier.showTaskField)
                  Row(
                    children: [
                      //text field
                      Expanded(
                        child: TextField(
                          controller: subTaskController,
                          onChanged: (value) {
                            if (subTaskController.text.isNotEmpty) {
                              todoNotifier.setIsTypingSubTask(true);
                            } else {
                              todoNotifier.setIsTypingSubTask(false);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Add sub-task',
                            hintStyle: GoogleFonts.roboto(
                                fontSize: MyDimension.dim10,
                                color: const Color(0xFFC6C1C1),
                                fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Color(0xFF9BA1A9)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                      15.horizontalSpace,
                      Icon(
                        Icons.done_outlined,
                        color: todoNotifier.isTypingSubTask
                            ? const Color(0xFF10CFB1)
                            : Colors.grey,
                        size: 20,
                      ),
                      5.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          if (subTaskController.text.isNotEmpty) {
                            context
                                .read<TodoNotifier>()
                                .addSubTask(subTaskController.text);
                            subTaskController.clear();
                            context
                                .read<TodoNotifier>()
                                .setIsOneTempSubTask(true);
                            todoNotifier.setShowTaskField(false);
                            todoNotifier.setIsTypingSubTask(false);
                          }
                        },
                        child: CustomText(
                          requiredText: 'Add',
                          color: todoNotifier.isTypingSubTask
                              ? const Color(0xFF10CFB1)
                              : Colors.grey,
                          fontSize: MyDimension.dim12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                //new subtask
                10.verticalSpace,
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.plus,
                      color: Color(0xFF10CFB1),
                      size: 20,
                    ),
                    5.horizontalSpace,
                    GestureDetector(
                        onTap: () {
                          if (todoNotifier.isOneTempSubTask &&
                              !todoNotifier.showTaskField) {
                            context.read<TodoNotifier>().setShowTaskField(true);
                          }
                        },
                        child: CustomText(
                          requiredText: 'New sub-task',
                          fontSize: MyDimension.dim12,
                          color: const Color(0xFF10CFB1),
                        ))
                  ],
                ),
                20.verticalSpace,
                const CustomText(requiredText: 'Category'),
                5.verticalSpace,
                SizedBox(
                  height: 50.h,
                  width: mediaQuery.width,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                context.watch<TodoNotifier>().categories.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isChecked = List.generate(
                                            context
                                                .read<TodoNotifier>()
                                                .categories
                                                .length,
                                            (index) => false);
                                        isChecked[index] = !isChecked[index];
                                        context
                                            .read<TodoNotifier>()
                                            .setSelectedCategoryIndex(index);
                                        category = context
                                            .read<TodoNotifier>()
                                            .categories[index]['text'];
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: ShapeDecoration(
                                        color: isChecked[index]
                                            ? const Color(0xFF10CFB1)
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 120.w,
                                        maxWidth: 120.w,
                                        minHeight: 50.h,
                                        maxHeight: 50.h,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: isChecked[index],
                                            child: const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: CustomText(
                                              requiredText: context
                                                  .read<TodoNotifier>()
                                                  .categories[index]['text'],
                                              fontSize: MyDimension.dim12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                20.verticalSpace,
                const CustomText(requiredText: 'Additional detail'),
                5.verticalSpace,
                Form(
                  child: TextArea(
                    key: addDetailsKey,
                    borderRadius: 12,
                    borderColor: Colors.grey,
                    textEditingController: additionalDetailController,
                    validation: reasonValidation,
                    errorText: 'Please type a reason!',
                  ),
                ),
                40.verticalSpace,
                InkWell(
                  onTap: () async {
                    if (todoFormKey.currentState!.validate() &&
                        todoController.text.isNotEmpty &&
                        dateController.text.isNotEmpty &&
                        timeController.text.isNotEmpty &&
                        category.isNotEmpty) {
                      _todoModel.todoType = 'upcoming';
                      _todoModel.todoCategory = category;
                      _todoModel.todoDate = dateController.text;
                      _todoModel.todoTime = timeController.text;
                      _todoModel.todoIsCompleted = false;
                      _todoModel.todoIsDue = false;
                      _todoModel.todoSubTask = subTasks;
                      _todoModel.todoAddDetails =
                          additionalDetailController.text;
                      _todoModel.todoName = todoController.text;
                      _todoModel.todoFullDate = DateTime.now().toString();

                      final todos = SharedPreferencesManager.loadTodos('todos');

                      setState(() {
                        todos.add(_todoModel.toJson());
                      });

                      await SharedPreferencesManager.saveTodos(todos, 'todos');
                      routerConfig.pushReplacement(RoutesPath.successScreen);
                    }
                  },
                  child: Container(
                    height: 56,
                    alignment: Alignment.centerRight,
                    decoration: ShapeDecoration(
                        color: todoController.text.isNotEmpty &&
                                dateController.text.isNotEmpty &&
                                timeController.text.isNotEmpty &&
                                category.isNotEmpty
                            ? AppColor.appColor
                            : const Color(0xFFB6AFA8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Row(
                      children: [
                        100.horizontalSpace,
                        const Icon(
                          CupertinoIcons.plus,
                          color: Colors.white,
                          size: 20,
                        ),
                        10.horizontalSpace,
                        CustomText(
                          requiredText: 'Add To-do',
                          fontSize: MyDimension.dim16,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                40.verticalSpace
              ],
            ),
          ),
        ));
  }

  addTodos(List<Map<String, dynamic>> todos) {
    context.read<TodoNotifier>().addTodo(todos);
  }
}
