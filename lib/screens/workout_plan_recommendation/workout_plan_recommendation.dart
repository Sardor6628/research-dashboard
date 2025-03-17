import 'package:admin/business_logic/workout_plan_recomendation/workout_plan_cubit.dart';
import 'package:admin/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutPlanRecommendation extends StatefulWidget {
  const WorkoutPlanRecommendation({super.key});

  @override
  State<WorkoutPlanRecommendation> createState() => _WorkoutPlanRecommendationState();
}

class _WorkoutPlanRecommendationState extends State<WorkoutPlanRecommendation> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search Field and Check Button in the same row
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
              ElevatedButton(
                onPressed: () {
                  String userId = _userIdController.text.trim();
                  if (userId.isNotEmpty) {
                    context.read<WorkoutPlanCubit>().fetchWorkoutPlan(userId);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter a User ID")),
                    );
                  }
                },
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

                        // Categorized Muscle Groups Data
                        ...state.exerciseData.result.entries.map((entry) {
                          final muscleGroup = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.8),
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
                                Text(
                                    "Difference: ${muscleGroup.difference}"),
                                Text("Type Code: ${muscleGroup.typeCode}"),
                                const SizedBox(height: 5),
                                const Text(
                                  "Similar Exercises:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                ...muscleGroup.similarExercises.map(
                                      (exercise) => Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text("- ${exercise.name}"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 20),

                        // Ranked List of Exercises
                        const Text(
                          "Ranked Exercises:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...state.exerciseData.allSortedExercises.map(
                              (exercise) => Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(exercise.name),
                              subtitle: Text(
                                  "Similarity: ${exercise.similarityPercentage}%"),
                              trailing: Text(
                                "${exercise.weightedScore.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is WorkoutPlanError) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text("Enter a User ID and tap 'Check'"));
              },
            ),
          ),
        ],
      ),
    );
  }
}