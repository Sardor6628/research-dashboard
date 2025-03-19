import 'package:admin/business_logic/workout_plan_recomendation/workout_plan_cubit.dart';
import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutPlanRecommendation extends StatefulWidget {
  const WorkoutPlanRecommendation({super.key});

  @override
  State<WorkoutPlanRecommendation> createState() =>
      _WorkoutPlanRecommendationState();
}

class _WorkoutPlanRecommendationState extends State<WorkoutPlanRecommendation> {
  final TextEditingController _userIdController = TextEditingController();
  String? _selectedTestUserId;

  final List<String> testUserIds = [
    "c50ace03-ee22-4c3b-9216-2cb26e604f1a",
    "29910456-f0fe-4d06-9a6f-0c007d59b098",
    "0675fce0-a5be-48d6-b9a4-67d8419399c7",
    "c221a725-b4c8-4bfc-b95c-048d3af76c5a",
    "5f2a8676-981c-4266-bb27-bba240c94d62",
    "3280d6b9-c397-4e92-a700-c699563fb4c9",
    "792d34bf-235b-4148-9280-fa288a81054b"
  ];

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  void _fetchWorkoutPlan() {
    String userId = _userIdController.text.trim();
    if (userId.isNotEmpty) {
      context.read<WorkoutPlanCubit>().fetchWorkoutPlan(userId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter or select a User ID")),
      );
    }
  }

  @override
  void initState() {
    _userIdController.text = "c50ace03-ee22-4c3b-9216-2cb26e604f1a";
    _fetchWorkoutPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Field, Dropdown, and Check Button
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _userIdController,
                  decoration: InputDecoration(
                    labelText: "Enter User ID",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _userIdController.clear(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Dropdown for test User IDs
              DropdownButton<String>(
                hint: const Text("Select Test User"),
                value: _selectedTestUserId,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTestUserId = newValue;
                    _userIdController.text = newValue ?? "";
                  });
                  context
                      .read<WorkoutPlanCubit>()
                      .fetchWorkoutPlan(_userIdController.text);
                },
                items: testUserIds.map((String userId) {
                  return DropdownMenuItem(
                    value: userId,
                    child: Text(userId),
                  );
                }).toList(),
              ),
              const SizedBox(width: 10),

              // Check Button
              ElevatedButton(
                onPressed: _fetchWorkoutPlan,
                child: const Text("Check"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // BlocBuilder for fetching state
          Expanded(
            child: BlocBuilder<WorkoutPlanCubit, WorkoutPlanState>(
              builder: (context, state) {
                if (state is WorkoutPlanLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WorkoutPlanLoaded) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Display
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Status: ${state.exerciseData.status}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Wrap for Categorized Muscle Groups Data
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children:
                              state.exerciseData.result.entries.map((entry) {
                            final muscleGroup = entry.value;
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: secondaryColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Muscle Group: ${entry.key}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text("Weak Side: ${muscleGroup.weakSide}"),
                                  Text("Difference: ${muscleGroup.difference}"),
                                  Text("Type Code: ${muscleGroup.typeCode}"),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "Similar Exercises:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...muscleGroup.similarExercises.map(
                                    (exercise) => Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                          "- ${exercise.name} | ${exercise.similarityPercentage}% | ${exercise.weightedScore}%"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // Ranked List of Exercises
                        const Text(
                          "Recommended Exercises:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: List.generate(
                            state.exerciseData.allSortedExercises.length,
                            (index) {
                              final exercise =
                                  state.exerciseData.allSortedExercises[index];
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.blue.shade700,
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            exercise.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "Similarity: ${exercise.similarityPercentage}% | Type: ${exercise.typeCode}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Tooltip(
                                      message: "Weighted Score - (Importance)",
                                      child: Text(
                                        "${exercise.weightedScore.toStringAsFixed(2)}%",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Top 5 Workout Plans Section
                        const Text(
                          "🏋️‍♂️ Top 5 Recommended Workout Plans:",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        SizedBox(height: 10),
                        ...state.exerciseData.top5.map(
                          (plan) => Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: ListTile(
                              leading: const Icon(Icons.fitness_center),
                              title: Text(plan.workoutName),
                              trailing: Text("Matches: ${plan.matchingCount}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(
                    child: Text("Enter a User ID and tap 'Check'"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
