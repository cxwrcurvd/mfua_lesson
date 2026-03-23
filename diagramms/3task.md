```mermaid
classDiagram
    class Book {
        +String title
        +String author
        +String ISBN
        +Boolean isAvailable
        +checkAvailability()
        +borrowBook()
        +returnBook()
    }

    class User {
        +String name
        +String userId
        +Book[] borrowedBooks
        +borrowBook(book)
        +returnBook(book)
        +getBorrowedBooks()
    }

    class Library {
        +Book[] books
        +User[] users
        +addBook(book)
        +removeBook(book)
        +registerUser(user)
        +findBookByTitle(title)
    }

    User "*" -- "*" Book : агрегация
    Library "1" o-- "*" Book : композиция
    Library "1" o-- "*" User : композиция