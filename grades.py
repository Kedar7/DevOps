"""
grades.py

Simple CLI for:
1. Grade Checker (score -> letter grade)
2. Student Grades dictionary (add, update, list)
3. Write to a text file
4. Read from a text file

Usage: run `python3 grades.py` and follow the menu prompts.
"""

import os

STUDENTS = {}


def grade_from_score(score: float) -> str:
    if score >= 90:
        return "A"
    if score >= 80:
        return "B"
    if score >= 70:
        return "C"
    if score >= 60:
        return "D"
    return "F"


def grade_checker():
    try:
        s = float(input("Enter numeric score (0-100): "))
    except ValueError:
        print("Invalid input — please enter a number.")
        return
    if s < 0 or s > 100:
        print("Score out of expected range (0-100).")
        return
    print(f"Score: {s} -> Grade: {grade_from_score(s)}")


def add_student():
    name = input("Student name: ").strip()
    if not name:
        print("Name cannot be empty")
        return
    try:
        score = float(input("Score (0-100): "))
    except ValueError:
        print("Invalid score")
        return
    STUDENTS[name] = grade_from_score(score)
    print(f"Added {name} with grade {STUDENTS[name]}")


def update_student():
    name = input("Student name to update: ").strip()
    if name not in STUDENTS:
        print("Student not found. Use add to create a new record.")
        return
    try:
        score = float(input("New score (0-100): "))
    except ValueError:
        print("Invalid score")
        return
    STUDENTS[name] = grade_from_score(score)
    print(f"Updated {name} to grade {STUDENTS[name]}")


def list_students():
    if not STUDENTS:
        print("No students recorded.")
        return
    print("Student Grades:")
    for name, grade in STUDENTS.items():
        print(f"- {name}: {grade}")


def write_to_file():
    filename = input("Filename to write to (default: output.txt): ").strip() or "output.txt"
    content = input("Content to write: ")
    try:
        with open(filename, "w", encoding="utf-8") as f:
            f.write(content + "\n")
        print(f"Wrote to {filename}")
    except OSError as e:
        print("Failed to write file:", e)


def read_from_file():
    filename = input("Filename to read from (default: output.txt): ").strip() or "output.txt"
    if not os.path.exists(filename):
        print("File does not exist.")
        return
    try:
        with open(filename, "r", encoding="utf-8") as f:
            print(f"--- Contents of {filename} ---")
            print(f.read())
            print(f"--- End of {filename} ---")
    except OSError as e:
        print("Failed to read file:", e)


def main_menu():
    MENU = (
        "1) Grade Checker (score -> letter)",
        "2) Add student and grade",
        "3) Update student grade",
        "4) List all student grades",
        "5) Write to a file",
        "6) Read from a file",
        "7) Exit",
    )
    while True:
        print("\n" + "\n".join(MENU))
        choice = input("Choose an option: ").strip()
        if choice == "1":
            grade_checker()
        elif choice == "2":
            add_student()
        elif choice == "3":
            update_student()
        elif choice == "4":
            list_students()
        elif choice == "5":
            write_to_file()
        elif choice == "6":
            read_from_file()
        elif choice == "7":
            print("Goodbye")
            break
        else:
            print("Invalid choice — enter a number 1-7")


if __name__ == "__main__":
    main_menu()
