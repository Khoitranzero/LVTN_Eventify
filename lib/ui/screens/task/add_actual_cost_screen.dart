// import 'package:Eventify/data/provider/event_provide.dart';
// import 'package:Eventify/data/repository/cost/costRepository.dart';
// import 'package:Eventify/ui/component/modal/selectCategoryModal.dart';
// import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
// import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddActualCostScreen extends StatefulWidget {

//   const AddActualCostScreen({Key? key}) : super(key: key);

//   @override
//   _AddActualCostScreenState createState() => _AddActualCostScreenState();
// }

// class _AddActualCostScreenState extends State<AddActualCostScreen> {
//   String? selectedCategoryId;
//   String? selectedCategoryName;
//   final TextEditingController _actualController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _categoryController = TextEditingController();

//   final CostRepository _costRepository = CostRepository();
//   List<CategoryItem> categories = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchAllCategory();
//   }

//   Future<void> fetchAllCategory() async {
//     try {
//       final response = await _costRepository.getAllCategory();
//       if (response['EC'] == 0) {
//         setState(() {
//           categories = (response['DT'] as List).map((category) {
//             return CategoryItem(
//               categoryId: category['id'],
//               categoryName: category['name'],
//             );
//           }).toList();
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _addActualCost() async {
//     final eventProvider = Provider.of<EventProvider>(context, listen: false);

//     if (_descriptionController.text.isNotEmpty &&
//         _actualController.text.isNotEmpty &&
//         selectedCategoryId != null) {
//       final response = await _costRepository.createTaskCost(
//         eventProvider.taskId,
//         selectedCategoryId!,
//         _actualController.text.trim(),
//         _descriptionController.text.trim(),
//       );

//       if (response['EC'] == 0) {
//         Navigator.pop(context);
//       } else {
//         // Handle error
//         print("Error creating task: ${response['EM']}");
//       }
//     } else {
//       // Handle validation error
//       print("Please fill all the fields");
//     }
//   }

//   void _showCategoryDialog() async {
//     final result = await showDialog<CategoryItem>(
//       context: context,
//       builder: (BuildContext context) {
//         return SelectCategoryModal(categories: categories);
//       },
//     );

//     if (result != null) {
//       setState(() {
//         selectedCategoryId = result.categoryId;
//         selectedCategoryName = result.categoryName;
//         _categoryController.text = result.categoryName;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _actualController.dispose();
//     _categoryController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }
//   Widget build(BuildContext context) {
//     return Scaffold(
//            appBar: AppBar(
//         title: Text('Thêm chi phí công việc'),
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                      UIAppTextField(
//                         hintText: "Chọn danh mục",
//                         labelText: "Chọn danh mục",
//                         isReadOnly: true,
//                         textController: _categoryController,
//                         onTap: _showCategoryDialog,
//                         ),
//                     SizedBox(height: 16.0),
//                      UIAppTextField(
//                         hintText: "Mô tả",
//                         labelText: "Mô tả",
//                         isReadOnly: false,
//                         textController: _descriptionController,
//                         ),
//                     SizedBox(height: 16.0),
//                      UIAppTextField(
//                         hintText: "Chi Phí",
//                         labelText: "Chi Phí",
//                         isReadOnly: false,
//                         textController: _actualController,
//                         keyboardType: TextInputType.number,
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//             bottomNavigationBar: Container(
//         padding: EdgeInsets.all(8.0),
//         color: Colors.white,
//         child: Row(
//           children: [
//             UICustomButton(
//                 buttonText: "Thêm Chi Phí",
//                 onPressed: _addActualCost,
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }
