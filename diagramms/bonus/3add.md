```mermaid
erDiagram
    USERS {
        int user_id PK
        string name
        string email
        string phone
        string address
    }
    
    RESTAURANTS {
        int restaurant_id PK
        string name
        string cuisine_type
        string address
        string phone
    }
    
    ORDERS {
        int order_id PK
        int user_id FK
        int restaurant_id FK
        decimal total_amount
        string status
        datetime order_date
    }
    
    ORDER_ITEMS {
        int item_id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal price
    }
    
    COURIERS {
        int courier_id PK
        string name
        string vehicle
        string phone
    }
    
    USERS ||--o{ ORDERS : places
    RESTAURANTS ||--o{ ORDERS : receives
    ORDERS ||--o{ ORDER_ITEMS : contains
    ORDERS ||--o| COURIERS : assigned_to