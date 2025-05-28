import 'package:expence_master/models/expence.dart';
import 'package:expence_master/server/database.dart';
import 'package:expence_master/widgets/add_new_expence.dart';
import 'package:expence_master/widgets/expence_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {

  final _myBox = Hive.box("expenceDatabase");
  Database db = Database();


  // final List <ExpenceModel> _expenceList = [
  //   ExpenceModel(
  //     amount: 12.5, 
  //     title: "Football", 
  //     date: DateTime.now(), 
  //     category: Category.leasure
  //   ),
  //   ExpenceModel(
  //     amount: 10, 
  //     title: "Carrot", 
  //     date: DateTime.now(), 
  //     category: Category.food
  //   ),
  //   ExpenceModel(
  //     amount: 20, 
  //     title: "Bag", 
  //     date: DateTime.now(), 
  //     category: Category.travel
  //   )
  // ];
  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leasure": 0,
    "Work": 0,
  };

  //function to add a new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      calCategoryValues();
    });
    db.updateData();
  }
  
  //function to open a model overlay
  void _openAddExpencesOverlay(){

    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return AddNewExpence(onAddExpence: onAddNewExpence,);
      },
    );

  }

  //remove the expence from the list
  void onDeleteExpence(ExpenceModel expence) {

    //store the deleted expence 
    ExpenceModel deletingExpence = expence;

    //get the index of the expence that delete
    final removedIndex = db.expenceList.indexOf(expence);
    
    setState(() {
      db.expenceList.remove(expence);
      db.updateData();
      calCategoryValues();
    });

    //show snack bar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Delete Sucessful"),
      action: SnackBarAction(label: "Undo", 
      onPressed: () {
        setState(() {
          db.expenceList.insert(removedIndex, deletingExpence);
          db.updateData();
          calCategoryValues();
        });
      },
      ),
      ),
    );
  }

  //pie chart
  double foodVal = 0;
  double travelVal = 0;
  double leasureVal = 0;
  double workVal = 0;

  void calCategoryValues() {
    double foodValTot = 0;
    double travelValTot = 0;
    double leasureValTot = 0;
    double workValTot = 0;

    for(final expence in db.expenceList) {

      if(expence.category == Category.food){
        foodValTot += expence.amount;
      }

      if(expence.category == Category.travel){
        travelValTot += expence.amount;
      }

      if(expence.category == Category.leasure){
        leasureValTot += expence.amount;
      }

      if(expence.category == Category.work){
        workValTot += expence.amount;
      }

    }

    setState(() {
      foodVal = foodValTot;
      travelVal = travelValTot;
      leasureVal = leasureValTot;
      workVal = workValTot;
    });

    //update the datamap
    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Leasure": leasureVal,
      "Work": workVal,
    };
  }

  @override
  void initState() {
    super.initState();

    //if this is the first time create the initial data
    if(_myBox.get("EXP_DATA") == null ) {
      db.createInitialDatabase();
      calCategoryValues();
    }else{
      db.loadData();
      calCategoryValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),  // Adjust height here
        child: AppBar(
          title: Text(
            "Expense Master",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color.fromARGB(255, 77, 4, 195),
          elevation: 0,
          actions: [
            Container(
              height: 60,
              color: Colors.amberAccent,
              child: IconButton(
                onPressed: _openAddExpencesOverlay,
                icon: Icon(Icons.add, color: Colors.black, size: 30),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
            expenceList: db.expenceList, 
            onDeleteExpence: onDeleteExpence
          ),
        ],
      ),
    );
  }
}