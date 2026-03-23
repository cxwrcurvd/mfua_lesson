```mermaid
erDiagram
    USERS {
        int id PK
        string name
        string email
        datetime created_at
    }
    
    POSTS {
        int id PK
        string content
        int author_id FK
        datetime created_at
    }
    
    COMMENTS {
        int id PK
        string content
        int post_id FK
        int author_id FK
        datetime created_at
    }
    
    LIKES {
        int user_id PK,FK
        int post_id PK,FK
        datetime created_at
    }
    
    SUBSCRIPTIONS {
        int subscriber_id PK,FK
        int target_id PK,FK
        datetime created_at
    }
    
    USERS ||--o{ POSTS : creates
    USERS ||--o{ COMMENTS : writes
    USERS ||--o{ LIKES : gives
    USERS ||--o{ SUBSCRIPTIONS : subscribes
    POSTS ||--o{ COMMENTS : has
    POSTS ||--o{ LIKES : receives