import Foundation

// Structure pour représenter une question du quiz
struct Question: Codable {
    var question: String // La question
    var answers: [String] // Les réponses possibles
    var correctAnswerIndex: Int // L'index de la réponse correcte dans le tableau des réponses
    var feedback: String // Le feedback à afficher après avoir répondu à la question
    var difficulty: String // Le niveau de difficulté de la question
    var category: String // La catégorie de la question

    // Initialisateur de la structure
    init(question: String, answers: [String], correctAnswerIndex: Int, feedback: String, difficulty: String, category: String) {
        self.question = question
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.feedback = feedback
        self.difficulty = difficulty
        self.category = category
    }

    // Clés pour le décodage JSON
    private enum CodingKeys: String, CodingKey {
        case question, answers, correctAnswerIndex, feedback, difficulty, category
    }
}

// Structure pour représenter le quiz
struct Quiz: Codable {
    let questions: [Question]
}

// Fonction pour charger le quiz à partir d'un fichier JSON
func loadQuiz(from fileName: String) -> [Question]? {
    let decoder = JSONDecoder()

    // Récupérer le chemin du fichier JSON
    let currentDirectoryURL = URL(fileURLWithPath: #file).deletingLastPathComponent()
    let jsonFileURL = currentDirectoryURL.appendingPathComponent(fileName)

    do {
        let jsonData = try Data(contentsOf: jsonFileURL)
        do {
            let quiz = try decoder.decode(Quiz.self, from: jsonData)
            return quiz.questions
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    } catch {
        print("Error loading JSON file: \(error)")
        return nil
    }
}

// Fonction pour obtenir l'entrée de l'utilisateur
func getUserInput(prompt: String) -> String {
    print(prompt, terminator: "")
    return readLine() ?? ""
}

// Fonction pour afficher une question
// Fonction pour afficher une question avec sa difficulté
func displayQuestion(_ question: Question) {
    print("Category: \(question.category)") // Afficher la catégorie de la question
    print("Difficulty: \(question.difficulty)") // Afficher la difficulté de la question
    print(question.question)
    for (index, answer) in question.answers.enumerated() {
        print("\(index + 1). \(answer)")
    }
}


// Fonction pour valider l'entrée de l'utilisateur
func validateUserInput(input: String, maxIndex: Int) -> Int? {
    if let index = Int(input), index >= 1, index <= maxIndex {
        return index - 1
    } else {
        return nil
    }
}

// Fonction pour jouer au quiz

// Fonction pour jouer au quiz
func playQuiz(questions: [Question]) {
    var score = 0
    for question in questions {
        displayQuestion(question)
        let userInput = getUserInput(prompt: "Enter your choice: ")
        if let userChoice = validateUserInput(input: userInput, maxIndex: question.answers.count) {
            if userChoice == question.correctAnswerIndex {
                print("Correct!")
                print(question.feedback) 
                score += 1
            } else {
                print("Incorrect!")
             
            }
        } else {
            print("Invalid input. Please enter a valid choice.")
        }
        print() // Ajouter une ligne vide pour améliorer la lisibilité
    }
    print("Your score: \(score)/\(questions.count)")
}


// Fonction principale
func main() {
    let fileName = "Quiz.json" // Nom du fichier JSON contenant les questions
    if let questions = loadQuiz(from: fileName) {
        playQuiz(questions: questions)
    } else {
        print("Failed to load quiz.")
    }
}

// Appeler la fonction principale pour démarrer le programme
main()
