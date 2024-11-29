import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentQuestion = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;

  bool showReview = false; // For toggling the review section

  List<Map<String, Object>> questions = [
    {
      'question': 'What is a Noun?',
      'options': ['A name of a person', 'A type of verb', 'An adjective', 'A number'],
      'correctAnswer': 'A name of a person',
    },
    {
      'question': 'Which of these is a Pronoun?',
      'options': ['He', 'Run', 'Beautiful', 'Three'],
      'correctAnswer': 'He',
    },
    {
      'question': 'Which of the following is a collective noun?',
      'options': ['Herd', 'Walk', 'Quickly', 'Under'],
      'correctAnswer': 'Herd',
    },
    {
      'question': 'Which is not a noun?',
      'options': ['Love', 'John', 'Car', 'Running'],
      'correctAnswer': 'Running',
    },
    {
      'question': 'What type of noun is “happiness”?',
      'options': ['Concrete noun', 'Abstract noun', 'Collective noun', 'Proper noun'],
      'correctAnswer': 'Abstract noun',
    },
    {
      'question': 'Identify the proper noun.',
      'options': ['city', 'India', 'freedom', 'happiness'],
      'correctAnswer': 'India',
    },
    {
      'question': 'What is the plural of “child”?',
      'options': ['Childs', 'Children', 'Childer', 'Childrens'],
      'correctAnswer': 'Children',
    },
    {
      'question': 'Which one is a compound noun?',
      'options': ['Toothbrush', 'Teeth', 'Tooth', 'Brush'],
      'correctAnswer': 'Toothbrush',
    },
    {
      'question': 'What is a noun that shows ownership?',
      'options': ['Common noun', 'Collective noun', 'Possessive noun', 'Proper noun'],
      'correctAnswer': 'Possessive noun',
    },
    {
      'question': 'Which of the following is an uncountable noun?',
      'options': ['Apple', 'Water', 'Car', 'Dog'],
      'correctAnswer': 'Water',
    },
  ];

  List<String?> selectedAnswers = List<String?>.filled(10, null);
  bool testCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Your Knowledge'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Handle back press
          },
        ),
        backgroundColor: const Color(0xFF1F2C46),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Question Counter
            if (!testCompleted)
              Text(
                'Question ${currentQuestion + 1}/${questions.length}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(height: 20),

            // Enhanced Question Card
            _buildQuestionCard(),

            const SizedBox(height: 20),

            // Enhanced Answer Options
            if (!testCompleted) ..._buildOptionsList(),

            const SizedBox(height: 20),

            // Show Results and Review Button if Test is Completed
            if (testCompleted) _buildResults(),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1F2C46),
    );
  }

  Widget _buildQuestionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange, // Orange question bar
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        !testCompleted ? questions[currentQuestion]['question'] as String : 'Test Completed!',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  List<Widget> _buildOptionsList() {
    if (testCompleted) return []; // No options to show if test is completed

    List<String> options = questions[currentQuestion]['options'] as List<String>;

    return options.map((option) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedAnswers[currentQuestion] = option;
            if (option == questions[currentQuestion]['correctAnswer']) {
              correctAnswers++;
            } else {
              incorrectAnswers++;
            }

            if (currentQuestion < questions.length - 1) {
              currentQuestion++;
            } else {
              testCompleted = true;
            }
          });
        },
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selectedAnswers[currentQuestion] == option ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            option,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: selectedAnswers[currentQuestion] == option ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildResults() {
    double totalQuestions = questions.length.toDouble();
    double percentageCorrect = (correctAnswers / totalQuestions) * 100;
    double percentageIncorrect = (incorrectAnswers / totalQuestions) * 100;

    return Expanded(
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text('Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              PieChart(
                dataMap: {
                  "Correct": percentageCorrect,
                  "Incorrect": percentageIncorrect,
                },
                chartType: ChartType.ring,
                colorList: const [Colors.green, Colors.red],
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                centerText: "$correctAnswers/${questions.length}",
                ringStrokeWidth: 32,
                legendOptions: const LegendOptions(
                  legendPosition: LegendPosition.right,
                  showLegendsInRow: false,
                  legendTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You answered $correctAnswers out of ${questions.length} correctly!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Toggle the review section visibility
                    showReview = !showReview;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Adjust button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(showReview ? 'Hide Review' : 'Review Questions'),
              ),

              const SizedBox(height: 20),

              if (showReview)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Review the Questions:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    // List of Questions with Correct Answers
                    ..._buildReviewQuestions(),
                  ],
                ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Resetting the state for a new test
                    currentQuestion = 0;
                    correctAnswers = 0;
                    incorrectAnswers = 0;
                    selectedAnswers.fillRange(0, questions.length, null);
                    testCompleted = false;
                    showReview = false; // Hide review on retry
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Adjust button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReviewQuestions() {
    return questions.asMap().entries.map((entry) {
      int index = entry.key;
      var question = entry.value['question'] as String;
      var correctAnswer = entry.value['correctAnswer'] as String;
      var selectedAnswer = selectedAnswers[index];

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: $question',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Your Answer: ${selectedAnswer ?? "Not Answered"}',
              style: TextStyle(fontSize: 14, color: selectedAnswer == correctAnswer ? Colors.green : Colors.red),
            ),
            Text(
              'Correct Answer: $correctAnswer',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      );
    }).toList();
  }
}
