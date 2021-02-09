import 'habit.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:good_habit/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day4 of Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '#Day 4 - Good Habits'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller;
  Category addedHabitCategory;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //method for the Button inside the Modal Bottom Sheets
  _addNewhabit() {
    setState(() async {
      Habit newhabit = Habit(
        text: _controller.text,
        categoryString: EnumToString.convertToString(addedHabitCategory),
      );

      await DBProvider.db.newHabit(newhabit);
      setState(() {});
      Navigator.pop(this.context);
    });
  }

  //method for the ElevationButton
  _showAddHabitScreen() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) => Container(
              margin: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    "Add a new Good Habit",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  DropdownButton<Category>(
                      hint: Text("Category"),
                      value: addedHabitCategory,
                      onChanged: (Category newValue) {
                        setState(() {
                          addedHabitCategory = newValue;
                        });
                      },
                      items: Category.values.map((Category classType) {
                        return DropdownMenuItem<Category>(
                            value: classType,
                            child: Text(classType.toString()));
                      }).toList()),
                  ElevatedButton(
                    child: Text("Add"),
                    onPressed: () => _addNewhabit(),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Habit>>(
        future: DBProvider.db.getAllHabits(),
        builder: (BuildContext context, AsyncSnapshot<List<Habit>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Habit item = snapshot.data[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                    ),
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  key: Key(item.text),
                  onDismissed: (direction) {
                    DBProvider.db.deleteHabit(item.id);
                  },
                  child: HabitView(
                    text: item.text,
                    category: item.category,
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Ajoutez de nouvelles habitudes"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitScreen,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
