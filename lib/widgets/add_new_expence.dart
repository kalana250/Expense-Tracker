import 'package:expence_master/models/expence.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddNewExpence extends StatefulWidget {

  final void Function(ExpenceModel expence) onAddExpence;
  const AddNewExpence({super.key, required this.onAddExpence});

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.food;

  // Date picker variables
  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(DateTime.now().year - 1);
  final DateTime lastDate = DateTime(DateTime.now().year + 1);

  DateTime _selectedDate = DateTime.now();
  final DateFormat formattedDate = DateFormat.yMd();

  // Date picker method
  Future<void> _openDateModal() async {
    try {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    } catch (err) {
      print("Date Picker Error: ${err.toString()}");
    }
  }

  // Form submission handler
  void _handleFormSubmit() {
    final enteredTitle = _titleController.text.trim();
    final enteredAmount = double.tryParse(_amountController.text.trim());

    if (enteredTitle.isEmpty || enteredAmount == null || enteredAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter valid data"),
            content: Text(
              "Please enter data for the title and the amount here. The title can be emplty or the amount can't be less than 0"
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    }
    else{
      // Create a new expense model
      ExpenceModel newExpence = ExpenceModel(
        amount: enteredAmount, 
        title: _titleController.text.trim(), 
        date: _selectedDate, 
        category: _selectedCategory
        );

      //save the data
     widget.onAddExpence(newExpence);
     Navigator.pop(context);

      //clear the text fields
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedCategory = Category.food;
        _selectedDate = DateTime.now();
      });
    }
    
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Add new expense title",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: "Enter the amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate.format(_selectedDate)),
                    IconButton(
                      onPressed: _openDateModal,
                      icon: Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton<Category>(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              Spacer(),

              //close button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: Text("Close"),
              ),
              SizedBox(width: 10),
              //save button
              ElevatedButton(
                onPressed: _handleFormSubmit,
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                child: Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
