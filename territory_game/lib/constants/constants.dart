import 'package:flutter/material.dart';
import 'package:flutter_smooth_markdown/flutter_smooth_markdown.dart';

/// This file contains classes of constant values for global use throughout the application.

/// A class of color constants.
class AppColors {
  static const darkBlue = Color.fromARGB(255, 33, 48, 68);
  static const blue = Color.fromARGB(255, 45, 65, 90);
  static const opaqueWhite = Color.fromARGB(164, 255, 255, 255);
  static const heartRed = Color.fromARGB(165, 244, 67, 54);
  static const pitRed = Color.fromARGB(255, 165, 55, 51);
  static const battlegroundPurple = Color.fromARGB(255, 118, 50, 135);
  static const arenaGreen = Color.fromARGB(255, 87, 138, 50);
  static const dojoGrey = Color.fromARGB(255, 78, 101, 123);
  static const propertyBlack = Colors.black;
  static const propertyWhite = Colors.white;
  static const backgroundCream = Color.fromARGB(255, 217, 213, 206);
  static const correctBoxGreen = Color.fromARGB(177, 74, 113, 57);
  static const midBoxYellow = Color.fromARGB(137, 255, 197, 8);
  static const wrongBoxRed = Color.fromARGB(185, 113, 57, 57);
  static const selectedBlue = Color.fromARGB(255, 69, 99, 136);
  static const dividerWhite = Color.fromARGB(61, 251, 252, 252);
}

/// A class of common dimensions.
class AppDimensions {
  static final cornerRadius = BorderRadius.circular(15.0);
  static final boardRows = 10;
  static final boardCols = 10;
}

/// Renders inline code as a padded, rounded box so its style survives the package's span conversion.
class _InlineCodeSpanBuilder extends MarkdownWidgetBuilder {
  const _InlineCodeSpanBuilder();

  @override
  bool canBuild(MarkdownNode node) => node is InlineCodeNode;

  @override
  Widget build(
    MarkdownNode node,
    MarkdownStyleSheet styleSheet,
    MarkdownRenderContext context,
  ) {
    return Text.rich(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            (node as InlineCodeNode).code,
            style: styleSheet.inlineCodeStyle?.copyWith(
              fontSize: 16,
              color: const Color.fromARGB(255, 241, 241, 241),
            ),
          ),
        ),
      ),
    );
  }
}

class MarkdownStyles {
  static final markdownConfig = MarkdownConfig(
    enableCodeHighlight: true,
    syntaxHighlightTheme: "github",
  );
  static final markdownBuilders = BuilderRegistry()
    ..register('inline_code', const _InlineCodeSpanBuilder());
  static final codeTextStyle = TextStyle(
    fontFamily: "CourierNew",
    fontFamilyFallback: const ["monospace"],
    fontSize: 18,
    height: 1.35,
    color: AppColors.opaqueWhite,

  );

  static final markdownStyle =
      MarkdownStyleSheet.dark(
        baseStyle: const TextStyle(
          fontSize: 16,
          height: 1.3,
          color: AppColors.opaqueWhite,
        ),
      ).copyWith(
        codeBlockStyle: codeTextStyle,
        codeBlockDecoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Colors.transparent,
          border: Border.all(color: const Color.fromARGB(64, 255, 255, 255)),
        ),
        codeBlockPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        inlineCodeStyle: const TextStyle(
          fontFamily: "CourierNew",
          fontFamilyFallback: ["monospace"],
          fontSize: 16,
        ),
        blockSpacing: 10,
        
      );
}

/// A class for the rules of the app.
class AppRules {
  static const rules = """
    This is a multiplayer territory board game.
    The object of the game is to have more control points than your opponent at the end of the time limit.

    PLACING PROPERTIES:

    Players earn pieces ("properties") to place on the board by completing activities.
    Click "+ New property" in the sidebar to begin an activity.
    Set the desired activity settings and complete the activity.
    The score you get in the activity makes up your new property's health points.
    The questions you answer get saved inside the new property. 
    Upon completion, you will have a new property to place in the "Properties" tab of the sidebar.
    Drag it onto the board to place it. 

    CONTROL POINTS:

    Different areas of the board provide different numbers of control points.
    -	Centre (RED): “The Pit” – 10 control points
    -	2nd from centre (PURPLE): “The Battleground” – 5 control points
    -	3rd from centre (GREEN): “The Arena” – 2 control points
    -	Outer ring (GREY): “The Dojo" – 1 control point

    ATTACKING:

    Click and drag from your own property to an opponent's to attack it.
    Properties must be directly adjacent to be able to attack each other.
    If you beat your opponent's score on the questions saved in their property, it becomes yours.
    If you fail, your attacking property will lose half of its health.
    If your opponetn

    STRENGTHENING: 

    Click on one of your own properties to strengthen it.
    This allows you to add more questions to the property with the existing activity type and topic.

    """;
}

class ChatbotSchemas {
  static const Map<String, dynamic> quizSchemas = {
    "multipleChoice": {
      "quizType": {
        "type": "string",
        "description":
            "This value must be: multipleChoice. It describes the quiz type.",
      },
      "subTopic": {
        "type": "string",
        "description": "Return the sub-topic provided in the prompt.",
      },
      "difficulty": {
        "type": "string",
        "description": "Return the difficulty that was provided in the prompt.",
      },
      "questions": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set.",
            },
            "question": {"type": "string"},
            "correctAnswer": {"type": "string"},
            "distractors": {
              "type": "array",
              "items": {"type": "string"},
            },
          },
        },
      },
    },
    "codingProblem": {
      "quizType": {
        "type": "string",
        "description":
            "The value must be: codingProblem. It describes the quiz type.",
      },
      "subTopic": {
        "type": "string",
        "description": "Return the sub-topic provided in the prompt",
      },
      "difficulty": {
        "type": "string",
        "description": "Return the difficulty that was provided in the prompt.",
      },
      "questions": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "question": {
              "type": "string",
              "description": "The Leetcode / Codewars style question ONLY.",
            },
            "inputExample": {
              "type": "string",
              "description": "This is an example of the type of input the user can expect to receive for the problem.",
            },
            "outputExample": {
              "type": "string",
              "description": "This is an example of the type of output that the problem expects the user to produce.",
            },
          },
        },
      },
    },
    "codingExercise": {
      "quizType": {
        "type": "string",
        "description":
            "The value must be: codingExercise. It describes the quiz type.",
      },
      "subTopic": {
        "type": "string",
        "description": "Return the sub-topic provided in the prompt",
      },
      "difficulty": {
        "type": "string",
        "description": "Return the difficulty that was provided in the prompt.",
      },
      "questions": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "question": {
              "type": "string",
              "description":
                  "For a coding exercise, this is a short summary of the task",
            },
            "steps": {
              "type": "array",
              "description": "Each item in the array is a coding instruction. They progress chronologically. There can be 2 - 5 steps.",
              "items": {
                "type": "string",
                "description": "A step in the coding exercise. Content only, no titles or numbers. This will be presented in markdown, so use backticks for any code-related or numerical elements and structure the step so it is clear and readable.",
              },
            },
          },
        },
      },
    },
    "theory": {
      "quizType": {
        "type": "string",
        "description": "The value must be: theory. It describes the quiz type.",
      },
      "subTopic": {
        "type": "string",
        "description": "Return the sub-topic provided in the prompt",
      },
      "difficulty": {
        "type": "string",
        "description": "Return the difficulty that was provided in the prompt.",
      },
      "questions": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "question": {
              "type": "string",
              "description": "The theory question ONLY.",
            },
          },
        },
      },
    },
  };

  static const Map<String, dynamic> feedbackSchemas = {
    "multipleChoice": {
      "quizType": {
        "type": "string",
        "description":
            "This value must be: multipleChoice. It describes the quiz type.",
      },
      "results": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "feedback": {"type": "string"},
            "score": {"type": "integer"},
          },
        },
      },
    },
    "codingProblem": {
      "quizType": {
        "type": "string",
        "description":
            "The value must be: codingProblem. This is the quiz type.",
      },
      "results": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "feedback": {
              "type": "object",
              "properties": {
                "summary": {
                  "type": "string",
                  "description": "A concise overall assessment of the answer.",
                },
                "correctness": {
                  "type": "string",
                  "description": "Explain whether the solution is correct and identify any errors.",
                },
                "approach": {
                  "type": "string",
                  "description":
                      "Assess whether the solution's approach is appropriate.",
                },
                "edgeCases": {
                  "type": "string",
                  "description": "Identify relevant edge cases the solution handles or misses.",
                },
                "efficiency": {
                  "type": "string",
                  "description":
                      "Describe time and space complexity when applicable.",
                },
                "codeQuality": {
                  "type": "string",
                  "description": "Comment on readability, naming, and code organization when relevant.",
                },
              },
            },
            "codeExample": {
              "type": "string",
              "description":
                  "An optional example solution as a Markdown string containing a fenced Python code block (```python ... ```)."
                  "Include if the user's solution could reasonably be improved.",
            },
            "score": {
              "type": "integer",
              "description":
                  "A score out of 100 for the user's answer to the question.",
            },
          },
        },
      },
    },
    "codingExercise": {
      "quizType": {
        "type": "string",
        "description":
            "The value must be: codingExercise. This is the quiz type.",
      },
      "results": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "feedback": {
              "type": "object",
              "properties": {
                "summary": {
                  "type": "string",
                  "description": "A concise overall assessment of the answer.",
                },
                "stepFeedback": {
                  "type": "array",
                  "description":
                      "Give feedback on each coding exercise step.",
                  "items": {
                    "type": "object",
                    "properties": {
                      "stepId": {
                        "type": "integer",
                        "description":
                            "The chronological number of the exercise step.",
                      },
                      "completed": {
                        "type": "boolean",
                        "description":
                            "Whether the user completed this step correctly.",
                      },
                      "feedback": {
                        "type": "string",
                        "description": "A brief, specific comment on the user's work for this step. Consider how it could be improved.",
                      },
                      "codeExample": {
                        "type": "string",
                        "description": "An example of the step performed correctly, or with improvements. Return python markdown only."
                      }
                    },
                  },
                },
              },
            },
            "score": {
              "type": "integer",
              "description":
                  "A score out of 100 for the user's answer to the question.",
            },
          },
        },
      },
    },
    "theory": {
      "quizType": {
        "type": "string",
        "description": "The value must be: theory. This is the quiz type.",
      },
      "results": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {
              "type": "integer",
              "description":
                  "The chronological number of the question in the set",
            },
            "feedback": {
              "type": "string",
              "description": "Your feedback describing any mistakes, misunderstanding, and context.",
            },
            "score": {
              "type": "integer",
              "description":
                  "A score out of 100 for the user's answer to the question.",
            },
          },
        },
      },
    },
  };
}
